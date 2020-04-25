//
//  SantanderPaymentsApiNetworkService.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 15/02/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import Foundation

extension SantanderNetworkService {
    
    enum PaymentsApi: SantanderBaseNetworkService {
        case paymentInitiation(username: String)
        case paymentExecution(username: String, token: String)
        
        var url: URL {
            switch self {
            case .paymentInitiation,
                 .paymentExecution:
                return URL(string: provider.configuration.santander.apiUrl)!
            }
        }
        
        var parameters: [Parameter]? {
            switch self {
            default:
                return nil
            }
        }
        
        var path: String {
            switch self {
            case .paymentInitiation:
                return "/v2/payment-initiation"
            case .paymentExecution:
                return "/v2/payment-execution"
            }
        }
        
        var headers: [String: String] {
            switch self {
            case .paymentInitiation(let username):
                return ["accept": "application/json", "content-type": "application/json", "x-account-user": username]
            case .paymentExecution(let username, let token):
                return ["accept": "application/json", "content-type": "application/json", "x-account-user": username, "Authorization": "Bearer " + token, "x-ibm-client-id": provider.configuration.santander.clientId]
            }
        }
        
        var method: HTTPRequest {
            switch self {
            case .paymentInitiation,
                 .paymentExecution:
                return .post
            }
        }
        
        var requestAdapter: APIRequestAdapterProtocol? {
            switch self {
            case .paymentInitiation:
                return SantanderPaymentsApiRequestAdapter()
            default:
                return nil
            }
        }
        
        var requestRetrier: APIRequestRetrierProtocol? {
            switch self {
            case .paymentInitiation:
                return SantanderPaymentsApiRequestRetrier()
            default:
                return nil
            }
        }
        
        var cachePolicy: URLRequest.CachePolicy? {
            return .reloadIgnoringLocalCacheData
        }
    }
}
