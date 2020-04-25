//
//  SendMoneySantanderWorker.swift
//  AssignmentOpenBank
//
//  Created by pips on 15/02/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import Foundation

enum SendMoneySantanderError: Error {
    case intitiatePaymentSantanderError
    case accessDeniedError
    case sendError
}

struct SendMoneySantanderParameters {
    let redirectUri: String
    let accountFrom: String
    let residenceCountry: String
    let accountName: String
    let accountTo: String
    let currencyTo: String
    let amount: Decimal
    let currency: String
    let spendingPolicy: String
    let destinationCountry: String
    let concept: String
    let type: String
    let inmediately: Bool
    let userName: String
}

typealias SendMoneySantanderWorkerAlias = BaseWorker<SendMoneySantanderParameters, Result<String, SendMoneySantanderError>>

final class SendMoneySantanderWorker: SendMoneySantanderWorkerAlias {
    
    private let requestDispatcher: RequestDispatcherProtocol
    private let bodyMapper: SantanderTransferBodyMapper
    
    init(requestDispatcher: RequestDispatcherProtocol = SantanderRequestDispatcher(), bodyMapper: SantanderTransferBodyMapper = SantanderTransferBodyMapper()) {
        
        self.requestDispatcher = requestDispatcher
        self.bodyMapper = bodyMapper
        super.init()
    }
    
    override func job(input: SendMoneySantanderParameters, completion: @escaping (Result<String, SendMoneySantanderError>) -> Void) {
        
        let body = bodyMapper.getPaymentInitiationBody(input).dictionary
        
        let request = Request(service: SantanderNetworkService.PaymentsApi.paymentInitiation(username: input.userName), body: body)
        
        let handler: RequestDispatcherHandler<String> = { result in
            
            switch result {
            case .success:
                completion(.failure(.intitiatePaymentSantanderError))
            case .failure(let error):
                switch error {
                case .error(let code, let message):
                    if code == 403 && message["status"] as! String == "redirect_required" {
                        completion(.success(message["redirect_uri"] as! String))
                    } else if code == 403 && message["status"] as! String == "403" {
                        completion(.failure(.accessDeniedError))
                    } else {
                        completion(.failure(.intitiatePaymentSantanderError))
                    }
                default:
                    completion(.failure(.intitiatePaymentSantanderError))
                }
            }
        }
        requestDispatcher.dispatch(request: request, completion: handler)
    }
}
