//
//  SantanderAuthTokenKeychainBuilder.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 14/02/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import Foundation

enum SantanderAuthTokenKeychainBuilder: KeychainBuilder {
    
    typealias Item = SantanderModels.Token
    
    static var account =  "santanderAuthTokens"
    
    static var service: String {
        return "\(Bundle.identifier)-"
    }
    
    static func build() -> CodableKeychain<Item> {
        let keychain = Keychain(group: accessGroup, service: service, key: account)
        return CodableKeychain<Item>(keychain: keychain)
    }
    
}
