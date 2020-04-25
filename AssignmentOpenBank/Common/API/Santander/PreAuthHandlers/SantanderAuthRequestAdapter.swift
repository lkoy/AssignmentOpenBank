//
//  SantanderAuthRequestAdapter.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 30/01/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import Alamofire

class SantanderAuthRequestAdapter: APIRequestAdapterProtocol {
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        
        let authorisation = SantanderNetworkService.Config.clientId + ":" + SantanderNetworkService.Config.clientSecret
        let utf8str = authorisation.data(using: .utf8)

        urlRequest.setValue(SantanderNetworkService.Config.clientSecret, forHTTPHeaderField: "X-IBM-Client-Secret")
        urlRequest.setValue(SantanderNetworkService.Config.clientId, forHTTPHeaderField: "X-IBM-Client-Id")
        
        if let base64Encoded = utf8str?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0)) {
            urlRequest.setValue("Basic " + base64Encoded, forHTTPHeaderField: "Authorization")
        } else {
            urlRequest.setValue("Basic " + authorisation, forHTTPHeaderField: "Authorization")
        }
        
        return urlRequest
    }
    
}
