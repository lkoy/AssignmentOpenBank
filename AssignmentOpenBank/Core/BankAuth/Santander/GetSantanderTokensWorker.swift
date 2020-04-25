//
//  GetSantanderTokensWorker.swift
//  AssignmentOpenBank
//
//  Created by pips on 28/01/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import Foundation

enum GetSantanderTokensError: Error {
    case getTokenError
}

public struct GetSantanderTokensParameter {
    let code: String
}

typealias GetSantanderTokensWorkerAlias = BaseWorker<GetSantanderTokensParameter, Result<SantanderModels.Token, GetSantanderTokensError>>

final class GetSantanderTokensWorker: GetSantanderTokensWorkerAlias {
    
    private let requestDispatcher: RequestDispatcherProtocol
    
    init(requestDispatcher: RequestDispatcherProtocol = SantanderRequestDispatcher()) {
        
        self.requestDispatcher = requestDispatcher
        super.init()
    }
    
    override func job(input: GetSantanderTokensParameter, completion: @escaping (Result<SantanderModels.Token, GetSantanderTokensError>) -> Void) {
        
        let params: [Parameter] = [("grant_type", "authorization_code"), ("code", input.code), ("redirect_uri", SantanderNetworkService.Config.redirectUri)]
        let request = Request(service: SantanderNetworkService.Auth.getAccessToken, parametersBody: params)
        
        let handler: RequestDispatcherHandler<Api.Santander.Token> = { result in
            
            switch result {
            case .success(let tokenResult):
                completion(.success(SantanderTokensMapper.map(tokenResult)))
            case .failure:
                completion(.failure(.getTokenError))
            }
        }
        requestDispatcher.dispatch(request: request, completion: handler)
    }
}
