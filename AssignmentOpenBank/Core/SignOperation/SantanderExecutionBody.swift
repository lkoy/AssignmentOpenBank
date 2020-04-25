//
//  SantanderExecutionBody.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 16/02/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import Foundation

struct SantanderExecutionBody: Codable, Equatable {

    let signatureToken: String
    
    private enum CodingKeys: String, CodingKey {
        case signatureToken = "signature_token"
    }
}
