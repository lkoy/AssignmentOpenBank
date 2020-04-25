//
//  AuthSantanderBodyMapper.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 15/02/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import Foundation

protocol AuthSantanderBodyMapperProtocol {
    func getAuthSantanderBody(_ parameters: GetSantanderServiceAuthorisationParameters) -> AuthSantanderBody
}

final class AuthSantanderBodyMapper {

    final func getAuthSantanderBody(_ parameters: GetSantanderServiceAuthorisationParameters) -> AuthSantanderBody {
        
        let authBody = AuthSantanderBody(access: AuthSantanderBody.Scopes(accounts: [], balances: []), recurringIndicator: parameters.recurringIndicator, frequencyPerDay: parameters.frequency)

        return authBody
    }
}
