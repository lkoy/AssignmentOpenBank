//
//  SantanderPaymentsApiRequestAdapter.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 15/02/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import Alamofire

class SantanderPaymentsApiRequestAdapter: APIRequestAdapterProtocol {
    
    private let santanderKeychain: CodableKeychain<SantanderModels.Token>
    
    public init(santanderKeychain: CodableKeychain<SantanderModels.Token> = SantanderPreAuthTokenKeychainBuilder.build()) {
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
