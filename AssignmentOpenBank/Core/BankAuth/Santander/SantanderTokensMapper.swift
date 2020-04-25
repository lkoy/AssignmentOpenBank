//
//  SantanderTokensMapper.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 30/01/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import Foundation

final class SantanderTokensMapper {
    
    static func map(_ tokens: Api.Santander.Token) -> SantanderModels.Token {
        
        return SantanderModels.Token(accessToken: tokens.accessToken, refreshToken: tokens.refreshToken)
    }
}
