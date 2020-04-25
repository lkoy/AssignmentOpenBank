//
//  CodableKeychain.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 14/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

import Foundation

class CodableKeychain<T: Codable> {
    
    let keychain: Keychain
    
    init(keychain: Keychain) {
        self.keychain = keychain
    }
    
    func store(codable: T, user: String?) throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(codable)
        try keychain.store(data: data, user: user)
    }
    
    func fetch(user: String?) throws -> T {
        let data = try keychain.fetch(user: user)
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
    
    func delete() throws {
        try keychain.delete()
    }
    
}

//extension CodableKeychain where T == Session {
//
//    var isLoggedIn: Bool {
//        return (try? fetch()) != nil
//    }
//
//}
//
//extension CodableKeychain where T == PaymentModels.PaymentsAccessControl {
//
//    var isLoggedIn: Bool {
//        return (try? fetch()) != nil
//    }
//
//}
//
//extension CodableKeychain where T == AirMilesModels.Token {
//
//    var isLoggedIn: Bool {
//        return (try? fetch()) != nil
//    }
//
//}
