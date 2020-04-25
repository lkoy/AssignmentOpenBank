//
//  KeychainBuilder.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 14/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

protocol KeychainBuilder {
    associatedtype Item: Codable
    static var accessGroup: String? { get }
    static var service: String { get }
    static var account: String { get }
    static func build() -> CodableKeychain<Item>
}

extension KeychainBuilder {
    
    static var accessGroup: String? {
        return nil
    }
    
    static func build() -> CodableKeychain<Item> {
        let keychain = Keychain(group: accessGroup, service: service, key: account)
        return CodableKeychain<Item>(keychain: keychain)
    }
}
