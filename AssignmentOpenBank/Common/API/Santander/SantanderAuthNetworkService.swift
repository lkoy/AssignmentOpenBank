//
//  SantanderAuthNetworkService.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 28/01/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import Foundation

extension SantanderNetworkService {
    
    enum Auth: SantanderBaseNetworkService {
        case getAccessToken
        case refreshAccessToken
        case authorize(token: String)
        
        var url: URL {
            switch self {
            case .getAccessToken,
                 .refreshAccessToken,
                 .authorize:
                return URL(string: provider.configuration.santander.apiAuthUrl)!
            }
        }
        
        var parameters: [Parameter]? {
            switch self {
            case .authorize:
                return [Parameter(key: "client_id", value: provider.configuration.santander.clientId),
                        Parameter(key: "redirect_uri", value: provider.configuration.santander.redirectUri),
                        Parameter(key: "response_type", "code")]
            default:
                return nil
            }
        }
        
        var path: String {
            switch self {
            case .getAccessToken,
                 .refreshAccessToken:
                return "/token"
            case .authorize:
                return "/authorize/"
            }
        }
        
        var headers: [String: String] {
            switch self {
            case .getAccessToken,
                 .refreshAccessToken:
                return ["content-type": "application/x-www-form-urlencoded"]
            case .authorize(let token):
            return ["content-type": "application/json", "authorization": "Bearer " + token]
            }
        }
        
        var method: HTTPRequest {
            switch self {
            case .getAccessToken,
                 .refreshAccessToken,
                 .authorize:
                return .post
            }
        }
        
        var requestAdapter: APIRequestAdapterProtocol? {
            switch self {
            case .getAccessToken,
                 .refreshAccessToken:
                return SantanderAuthRequestAdapter()
            case .authorize:
                return nil
            }
        }
        
        var cachePolicy: URLRequest.CachePolicy? {
            return .reloadIgnoringLocalCacheData
        }
    }
}
