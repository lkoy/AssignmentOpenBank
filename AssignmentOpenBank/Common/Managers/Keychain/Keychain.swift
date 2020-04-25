//
//  Keychain.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 14/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

import Foundation

class Keychain {
    
    private let group: String?
    private let service: String
    private let key: String
    
    init(group: String? = nil, service: String, key: String) {
        self.group = group
        self.service = service
        self.key = key
    }
    
    func store(data: Data, user: String?) throws {
        do {
            _ = try load(user: user)
            var attributesToUpdate = [String: AnyObject]()
            attributesToUpdate[kSecValueData as String] = data as AnyObject?
            
            var serviceWithUser = service
            if let userUnw = user {
                serviceWithUser += userUnw
            }
            
            let query = keychainQuery(withService: serviceWithUser, account: key, accessGroup: group)
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            
            // Throw an error if an unexpected status was returned.
            guard status == noErr else {
                throw KeychainError.unhandledError(status: status)
            }
        } catch KeychainError.noData {
            /*
             No session was found in the keychain. Create a dictionary to save
             as a new keychain item.
             */
            var serviceWithUser = service
            if let userUnw = user {
                serviceWithUser += userUnw
            }
            
            var newItem = keychainQuery(withService: serviceWithUser, account: key, accessGroup: group)
            newItem[kSecValueData as String] = data as AnyObject?
            
            // Add a the new item to the keychain.
            let status = SecItemAdd(newItem as CFDictionary, nil)
            
            // Throw an error if an unexpected status was returned.
            //guard status == noErr else { throw KeychainError.unhandledError(status: status) }
            guard status == noErr else {
                throw KeychainError.unhandledError(status: status)
            }
        }
    }
    
    func fetch(user: String?) throws -> Data {
        guard let data =  try? load(user: user) else {
            throw KeychainError.noData
        }
        return data
    }
    
    func delete() throws {
        let query = keychainQuery(withService: service, account: key, accessGroup: group)
        let status = SecItemDelete(query as CFDictionary)
        guard status == noErr || status == errSecItemNotFound else { throw KeychainError.unhandledError(status: status) }
    }
    
    private func load(user: String?) throws -> Data {
        
        var serviceWithUser = service
        if let userUnw = user {
            serviceWithUser += userUnw
        }
        
        let query = oneItemQuery(withService: serviceWithUser, account: key, accessGroup: group)
        
        // Try to fetch the existing keychain item that matches the query.
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        // Check the return status and throw an error if appropriate.
        guard status != errSecItemNotFound else { throw KeychainError.noData }
        guard status == noErr else { throw KeychainError.unhandledError(status: status) }
        
        // Parse the session from the query result.
        guard let existingItem = queryResult as? [String: AnyObject],
            let data = existingItem[kSecValueData as String] as? Data
            else {
                throw KeychainError.unexpectedData
        }
        return data
    }
    
    private func keychainQuery(withService service: String, account: String? = nil, accessGroup: String? = nil) -> [String: AnyObject] {
        var query = [String: AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrService as String] = service as AnyObject?
        
        if let account = account {
            query[kSecAttrAccount as String] = account as AnyObject?
        }
        
        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup as AnyObject?
        }
        
        return query
    }
    
    private func oneItemQuery(withService service: String, account: String? = nil, accessGroup: String? = nil) -> [String: AnyObject] {
        var query = keychainQuery(withService: service, account: account, accessGroup: accessGroup)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanTrue
        return query
    }
    
}

enum KeychainError: Error, Equatable {
    case noData
    case unexpectedData
    case unhandledError(status: OSStatus)
}
