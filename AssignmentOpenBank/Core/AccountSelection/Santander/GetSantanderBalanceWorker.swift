//
//  GetSantanderBalanceWorker.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 17/02/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import Foundation

enum GetSantanderBalanceError: Error {
    case getBalanceError
    case UnAuthorisedError
}

struct GetSantanderBalanceParameters {
    let accountNumber: String
    let username: String
}

typealias GetSantanderBalanceWorkerAlias = BaseWorker<GetSantanderBalanceParameters, Result<BankModels.BankAccount, GetSantanderBalanceError>>

final class GetSantanderBalanceWorker: GetSantanderBalanceWorkerAlias {

    private let requestDispatcher: RequestDispatcherProtocol
    private let mapper: BankAccountMapper
    
    init(requestDispatcher: RequestDispatcherProtocol = SantanderRequestDispatcher(), bankAccountMapper: BankAccountMapper = BankAccountMapper()) {
        self.requestDispatcher = requestDispatcher
        self.mapper = bankAccountMapper
        super.init()
    }
    
    override func job(input: GetSantanderBalanceParameters, completion: @escaping ((Result<BankModels.BankAccount, GetSantanderBalanceError>) -> Void)) {

        let request = Request(service: SantanderNetworkService.Api.getBalance(username: input.username, number: input.accountNumber))
        
        let handler: RequestDispatcherHandler<Api.Santander.AccountBalance> = { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let balance):
                completion(.success(self.mapper.map(santanderBalance: balance, user: input.username)))
            case .failure(let error):
                completion(.failure(.getBalanceError))
            }
        }
        requestDispatcher.dispatch(request: request, completion: handler)
    }
}
