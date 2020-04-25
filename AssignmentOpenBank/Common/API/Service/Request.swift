//
//  Environment.swift
//  TestProject
//
//  Created by gustavo on 14/06/2019.
//  Copyright © 2019 ttg. All rights reserved.
//

import Foundation

struct Request: Equatable {
    let service: NetworkService
    
    var cachePolicy: URLRequest.CachePolicy? {
        return service.cachePolicy
    }
    
    let bodyData: Data?
    
    var headers: [String: String]
    
    var url: URL {
        var queries = [URLQueryItem]()
        var urlComponents = URLComponents(url: self.service.url, resolvingAgainstBaseURL: true)!
        urlComponents.path.append(self.service.path)
        
        if let parameters = self.service.parameters {
            for parameter in parameters {
                queries.append(URLQueryItem(name: parameter.key, value: parameter.value as? String))
            }
            
            urlComponents.queryItems = queries
        }
        
        return URL(string: (urlComponents.url?.absoluteString.removingPercentEncoding?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)!)!)!
    }
    
    let domain: String = Bundle.identifier
    
    init(service: NetworkService, body: [String: Any]? = nil, headers: [String: String]? = nil) {
        self.service = service
        if let json = body {
            self.bodyData = try? JSONSerialization.data(withJSONObject: json, options: [])
        } else {
            self.bodyData = nil
        }
        self.headers = headers?.merging(service.headers, uniquingKeysWith: { (_, new) in new}) ?? service.headers
    }
    
    init(service: NetworkService, parametersBody: [Parameter]?, headers: [String: String]? = nil) {
        self.service = service
        if let params = parametersBody {
            var queries = [URLQueryItem]()
            var urlComponents = URLComponents()
            for parameter in params {
                queries.append(URLQueryItem(name: parameter.key, value: parameter.value as? String))
            }
            urlComponents.queryItems = queries
            if let paramsString = urlComponents.query {
                self.bodyData = paramsString.data(using: .utf8)
            } else {
                self.bodyData = nil
            }
        } else {
            self.bodyData = nil
        }
        self.headers = headers?.merging(service.headers, uniquingKeysWith: { (_, new) in new}) ?? service.headers
    }
    
    init(service: NetworkService, arrayBody: [Any], headers: [String: String]? = nil) {
        self.service = service
        self.bodyData = try? JSONSerialization.data(withJSONObject: arrayBody, options: [])
        self.headers = headers?.merging(service.headers, uniquingKeysWith: { (_, new) in new}) ?? service.headers
    }
    
    static func == (lhs: Request, rhs: Request) -> Bool {
        return lhs.bodyData == rhs.bodyData
            && lhs.headers == rhs.headers
            && lhs.url == rhs.url
            && lhs.domain == rhs.domain
            && lhs.service.method == rhs.service.method
    }

}
