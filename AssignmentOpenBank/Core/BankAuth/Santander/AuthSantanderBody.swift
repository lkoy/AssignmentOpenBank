//
//  AuthSantanderBody.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 15/02/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import Foundation

struct AuthSantanderBody: Codable, Equatable {

    let access: Scopes?
    let recurringIndicator: Bool?
    let frequencyPerDay: Int?
    
    struct Scopes: Codable, Equatable {
        let accounts: [String]?
        let balances: [String]?
    }
}
