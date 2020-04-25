//
//  SantanderModels.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 28/01/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import Foundation

enum SantanderModels { }

extension SantanderModels {
    
    struct Token: Codable, Equatable {
        let accessToken: String
        let refreshToken: String
    }
}
