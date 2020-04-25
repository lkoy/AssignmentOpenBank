//
//  PaymentExecutionSantanderWorker.swift
//  AssignmentOpenBank
//
//  Created by pips on 16/02/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import Foundation

enum PaymentExecutionSantanderError: Error {
    case paymentExecutionError
}

struct PaymentExecutionSantanderParameters {
    let accesToken: String
    let signatureToken: String
    let userName: String
}

typealias PaymentExecutionSantanderWorkerAlias = BaseWorker<PaymentExecutionSantanderParameters, Result<BankModels.Transaction, PaymentExecutionSantanderError>>

final class PaymentExecutionSantanderWorker: PaymentExecutionSantanderWorkerAlias {
    
    private let requestDispatcher: RequestDispatcherProtocol
    private let bodyMapper: SantanderExecutionBodyMapper
    private let transactionMapper: TransactionMapper
    
    init(requestDispatcher: RequestDispatcherProtocol = SantanderRequestDispatcher(), bodyMapper: SantanderExecutionBodyMapper = SantanderExecutionBodyMapper(), transactionMapper: TransactionMapper = TransactionMapper()) {
        
        self.requestDispatcher = requestDispatcher
        self.bodyMapper = bodyMapper
        self.transactionMapper = transactionMapper
        super.init()
    }
    
    override func job(input: PaymentExecutionSantanderParameters, completion: @escaping (Result<BankModels.Transaction, PaymentExecutionSantanderError>) -> Void) {
        
        let body = bodyMapper.getPaymentExecutionBody(input).dictionary
        
        let request = Request(service: SantanderNetworkService.PaymentsApi.paymentExecution(username: input.userName, token: input.accesToken), body: body)
        
        let handler: RequestDispatcherHandler<Api.Santander.Transfer> = { result in
            
            switch result {
            case .success(let data):
                completion(.success(self.transactionMapper.map(apiTransaction: data)))
            case .failure:
                completion(.failure(.paymentExecutionError))
            }
        }
        requestDispatcher.dispatch(request: request, completion: handler)
    }
    
}
