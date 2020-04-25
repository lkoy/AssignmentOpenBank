//
//  RefreshTokensSantanderWorker.swift
//  AssignmentOpenBank
//
//  Created by pips on 16/02/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import Foundation

enum RefreshSantanderTokensError: Error {
    case refreshTokenError
    case storeTokenError
}

public struct RefreshSantanderTokensParameter {
    let userName: String
}

typealias RefreshSantanderTokensWorkerAlias = BaseWorker<RefreshSantanderTokensParameter, Result<SantanderModels.Token, RefreshSantanderTokensError>>

final class RefreshSantanderTokensWorker: RefreshSantanderTokensWorkerAlias {
    
    private let requestDispatcher: RequestDispatcherProtocol
    private let santanderTokenKeychain: CodableKeychain<SantanderModels.Token>
    
    init(requestDispatcher: RequestDispatcherProtocol = SantanderRequestDispatcher(),
         santanderTokenKeychain: CodableKeychain<SantanderModels.Token> = SantanderPreAuthTokenKeychainBuilder.build()) {
        
        self.requestDispatcher = requestDispatcher
        self.santanderTokenKeychain = santanderTokenKeychain
        super.init()
    }
    
    override func job(input: RefreshSantanderTokensParameter, completion: @escaping (Result<SantanderModels.Token, RefreshSantanderTokensError>) -> Void) {
            
        let santanderRefreshToken = try? santanderTokenKeychain.fetch(user: input.userName).refreshToken
        
        let authorisation = SantanderNetworkService.Config.clientId + ":" + SantanderNetworkService.Config.clientSecret
        let utf8str = authorisation.data(using: .utf8)
        var authValue = ""
        if let base64Encoded = utf8str?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0)) {
            authValue = "Basic " + base64Encoded
        } else {
            authValue = "Basic " + authorisation
        }
        
        let headers = ["X-IBM-Client-Secret": SantanderNetworkService.Config.clientSecret,
                       "X-IBM-Client-Id": SantanderNetworkService.Config.clientId,
                       "Authorization": authValue,
                       "accept": "application/json",
                       "Cache-Control": "no-cache, no-store"]
        
        let params: [Parameter] = [("grant_type", "refresh_token"), ("refresh_token", santanderRefreshToken ?? "")]
        
        let request = Request(service: SantanderNetworkService.Auth.refreshAccessToken, parametersBody: params, headers: headers)
        
        let handler: RequestDispatcherHandler<Api.Santander.Token> = { result in
            
            switch result {
            case .success(let tokenResult):
                let tokens = SantanderTokensMapper.map(tokenResult)
                do {
                    try self.santanderTokenKeychain.store(codable: tokens, user: input.userName)
                    completion(.success(tokens))
                } catch {
                    completion(.failure(.storeTokenError))
                }
            case .failure:
                completion(.failure(.refreshTokenError))
            }
        }
        requestDispatcher.dispatch(request: request, completion: handler)
    }
}
