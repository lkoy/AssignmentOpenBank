//
//  SantanderBaseNetworkService.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 28/01/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import Foundation

protocol SantanderBaseNetworkService: NetworkService {

}

extension SantanderBaseNetworkService {

    var url: URL {
        return URL(string: provider.configuration.santander.apiUrl)!
    }
}

enum SantanderNetworkService {
    
    struct Config {
        static var clientId: String {
            return provider.configuration.santander.clientId
        }
        
        static var clientSecret: String {
            return provider.configuration.santander.clientSecret
        }
        
        static var redirectUri: String {
            return provider.configuration.santander.redirectUri
        }
        
        static var maxNumberOfRetries = 1
    }
}
