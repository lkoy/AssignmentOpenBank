//
//  GetSantanderServiceAuthorisationWorker.swift
//  AssignmentOpenBank
//
//  Created by pips on 14/02/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import Foundation

enum GetSantanderServiceAuthorisationError: Error {
    case getSantanderServiceAuthorisationError
}

struct GetSantanderServiceAuthorisationParameters {
    let token: String
    let recurringIndicator: Bool
    let frequency: Int
}

typealias GetSantanderServiceAuthorisationWorkerAlias = BaseWorker<GetSantanderServiceAuthorisationParameters, Result<String, GetSantanderServiceAuthorisationError>>

final class GetSantanderServiceAuthorisationWorker: GetSantanderServiceAuthorisationWorkerAlias {
    
    private let requestDispatcher: RequestDispatcherProtocol
    private let bodyMapper: AuthSantanderBodyMapper
    
    init(requestDispatcher: RequestDispatcherProtocol = SantanderRequestDispatcher(), bodyMapper: AuthSantanderBodyMapper = AuthSantanderBodyMapper()) {
        
        self.requestDispatcher = requestDispatcher
        self.bodyMapper = bodyMapper
        super.init()
    }
    
    override func job(input: GetSantanderServiceAuthorisationParameters, completion: @escaping (Result<String, GetSantanderServiceAuthorisationError>) -> Void) {
        
        let body = bodyMapper.getAuthSantanderBody(input).dictionary
        let request = Request(service: SantanderNetworkService.Auth.authorize(token: input.token), body: body)
        
        let handler: RequestDispatcherHandler<String> = { result in
            
            switch result {
            case .success:
                completion(.failure(.getSantanderServiceAuthorisationError))
            case .failure(let error):
                switch error {
                case .error(let code, let message):
                    if code == 403 {
                        completion(.success(message["redirect_uri"] as! String))
                    } else {
                        completion(.failure(.getSantanderServiceAuthorisationError))
                    }
                default:
                    completion(.failure(.getSantanderServiceAuthorisationError))
                }
            }
        }
        requestDispatcher.dispatch(request: request, completion: handler)
    }
    
}
