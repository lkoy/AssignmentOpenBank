//
//  DispatcherProtocol.swift
//  TestProject
//
//  Created by gustavo on 15/06/2019.
//  Copyright © 2019 ttg. All rights reserved.
//

import Foundation

enum HTTPRequest: String, RawRepresentable {
    typealias RawValue = String
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

typealias Parameter = (key: String, value: Any)

protocol NetworkService {
    
    /// The target's base `URL`.
    var url: URL { get }
    
    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }
    
    /// The HTTP method used in the request.
    var method: HTTPRequest { get }
    
    /// The parameters to be encoded in the request.
    var parameters: [Parameter]? { get }
    
    /// The headers used in the request.
    var headers: [String: String] { get }
    
    /// Provides stub data for use in testing.
    var sampleData: Data? { get }
    
    var requestRetrier: APIRequestRetrierProtocol? { get }
    
    var requestAdapter: APIRequestAdapterProtocol? { get }
    
    var cachePolicy: URLRequest.CachePolicy? { get }
}

//Constants
extension NetworkService {
        
    var parameters: [String: Any]? {
        return nil
    }
    
    var headers: [String: String] {
        return [:]
    }
    
    var sampleData: Data? {
        return nil
    }
    
    var requestRetrier: APIRequestRetrierProtocol? {
        return nil
    }
    
    var requestAdapter: APIRequestAdapterProtocol? {
        return nil
    }
    
    var cachePolicy: URLRequest.CachePolicy? {
        return nil
    }
}
