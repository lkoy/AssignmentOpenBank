//
//  Configuration.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 29/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

import Foundation

struct Configuration {
    
    let general: General
    let santander: Santander
    
    struct General {
        let bankEntity: BankEntity
        
        enum BankEntity: String {
            case santander = "Santander"
        }
    }
    
    struct Santander {
        let authUrl: String
        let apiAuthUrl: String
        let apiUrl: String
        let clientSecret: String
        let clientId: String
        let redirectUri: String
        let bic: String
    }
}
