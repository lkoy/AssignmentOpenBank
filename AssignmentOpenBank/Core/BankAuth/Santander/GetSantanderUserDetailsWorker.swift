//
//  GetSantanderUserDetailsWorker.swift
//  AssignmentOpenBank
//
//  Created by pips on 06/02/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import Foundation

enum GetSantanderUserDetailsError: Error {
    case getUserDetailsError
}

typealias GetSantanderUserDetailsWorkerAlias = BaseWorker<String, Result<String, GetSantanderUserDetailsError>>

final class GetSantanderUserDetailsWorker: GetSantanderUserDetailsWorkerAlias {
    
    private let requestDispatcher: RequestDispatcherProtocol
    
    init(requestDispatcher: RequestDispatcherProtocol = SantanderRequestDispatcher()) {
        
        self.requestDispatcher = requestDispatcher
        super.init()
    }
    
    override func job(input: String, completion: @escaping (Result<String, GetSantanderUserDetailsError>) -> Void) {
        
        let request = Request(service: SantanderNetworkService.Api.getUserDetail(token: input))
        
        let handler: RequestDispatcherHandler<Api.Santander.UserDetails> = { result in
            
            switch result {
            case .success(let userDetails):
                completion(.success(userDetails.userId ?? ""))
            case .failure:
                completion(.failure(.getUserDetailsError))
            }
        }
        requestDispatcher.dispatch(request: request, completion: handler)
    }
    
}
