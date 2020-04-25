//
//  SantanderTokenKeychainBuilder.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 28/01/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import Foundation

enum SantanderPreAuthTokenKeychainBuilder: KeychainBuilder {
    
    typealias Item = SantanderModels.Token
    
    static var account =  "santanderPreAuthTokens"
    
    static var service: String {
        return "\(Bundle.identifier)-"
    }
    
    static func build() -> CodableKeychain<Item> {
        let keychain = Keychain(group: accessGroup, service: service, key: account)
        return CodableKeychain<Item>(keychain: keychain)
    }
    
}
