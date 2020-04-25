//
//  SantanderApiNetworkService.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 30/01/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import Foundation

extension SantanderNetworkService {
    
    enum Api: SantanderBaseNetworkService {
        case getAccounts(username: String)
        case getBalance(username: String, number: String)
        case getUserDetail(token: String)
        
        var url: URL {
            switch self {
            case .getAccounts,
                 .getUserDetail,
                 .getBalance:
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
            case .getAccounts:
                return "/v2/accounts"
            case .getBalance( _, let number):
                return "/v2/balances/\(number)"
            case .getUserDetail:
                return "/introspect"
            }
        }
        
        var headers: [String: String] {
            switch self {
            case .getAccounts(let username):
                return ["accept": "application/json", "x-account-user": username, "psu_active": "1"]
            case .getBalance(let username, _):
                return ["accept": "application/json", "x-account-user": username, "psu_active": "1"]
            case .getUserDetail(let token):
                return ["accept": "application/json", "X-IBM-Client-Secret": SantanderNetworkService.Config.clientSecret, "X-IBM-Client-Id": SantanderNetworkService.Config.clientId, "authorization": "Bearer " + token]
            }
        }
        
        var method: HTTPRequest {
            switch self {
            case .getAccounts,
                 .getBalance,
                 .getUserDetail:
                return .get
            }
        }
        
        var requestAdapter: APIRequestAdapterProtocol? {
            switch self {
            case .getAccounts,
                 .getBalance:
                return SantanderApiRequestAdapter()
            case .getUserDetail:
                return nil
            }
        }
        
        var requestRetrier: APIRequestRetrierProtocol? {
            switch self {
            case .getAccounts,
                 .getBalance:
                return SantanderApiRequestRetrier()
            case .getUserDetail:
                return nil
            }
        }
        
        var cachePolicy: URLRequest.CachePolicy? {
            return .reloadIgnoringLocalCacheData
        }
    }
}
