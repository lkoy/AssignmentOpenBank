//
//  GetSantanderAccountsWorker.swift
//  AssignmentOpenBank
//
//  Created by pips on 30/01/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import Foundation

enum GetSantanderAccountsError: Error {
    case getAccountError
    case UnAuthorisedError
}

typealias GetSantanderAccountsWorkerAlias = BaseWorker<String, Result<[BankModels.BankAccount], GetSantanderAccountsError>>

final class GetSantanderAccountsWorker: GetSantanderAccountsWorkerAlias {

    private let requestDispatcher: RequestDispatcherProtocol
    private let mapper: BankAccountMapper
    
    init(requestDispatcher: RequestDispatcherProtocol = SantanderRequestDispatcher(), bankAccountMapper: BankAccountMapper = BankAccountMapper()) {
        self.requestDispatcher = requestDispatcher
        self.mapper = bankAccountMapper
        super.init()
    }
    
    override func job(input: String, completion: @escaping ((Result<[BankModels.BankAccount], GetSantanderAccountsError>) -> Void)) {

        let request = Request(service: SantanderNetworkService.Api.getAccounts(username: input))
        
        let handler: RequestDispatcherHandler<Api.Santander.AccountData> = { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let accounts):
                completion(.success(self.mapper.map(santanderData: accounts, userName: input)))
            case .failure(let error):
                completion(.failure(.getAccountError))
            }
        }
        requestDispatcher.dispatch(request: request, completion: handler)
    }
}
