//
//  SantanderRequestAdapter.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 30/01/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import Alamofire

class SantanderApiRequestAdapter: APIRequestAdapterProtocol {
    
    private let santanderKeychain: CodableKeychain<SantanderModels.Token>
    
    public init(santanderKeychain: CodableKeychain<SantanderModels.Token> = SantanderAuthTokenKeychainBuilder.build()) {
        self.santanderKeychain = santanderKeychain
    }
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        
        
        var urlRequest = urlRequest
        urlRequest.setValue(SantanderNetworkService.Config.clientId, forHTTPHeaderField: "x-ibm-client-id")
        let user = urlRequest.value(forHTTPHeaderField: "x-account-user")
        if let accessToken = try? santanderKeychain.fetch(user: user).accessToken {
            urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
            return urlRequest
        }
        return urlRequest
    }
    
}
