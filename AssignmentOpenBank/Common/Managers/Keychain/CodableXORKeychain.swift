//
//  CodableXORKeychain.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 14/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

import Foundation

class CodableXORKeychain<T: Codable>: CodableKeychain<T> {
    
    private let hash: String
    
    init(keychain: Keychain, hash: String) {
        self.hash = hash
        super.init(keychain: keychain)
    }
    
    override func store(codable: T, user: String?) throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(codable)
        let encryptedData = Crypto.applyXOR(data, forHash: hash)
        try keychain.store(data: encryptedData, user: user)
    }
    
    override func fetch(user: String?) throws -> T {
        let data = try keychain.fetch(user: user)
        let decryptedData = Crypto.applyXOR(data, forHash: hash)
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: decryptedData)
    }
    
}
