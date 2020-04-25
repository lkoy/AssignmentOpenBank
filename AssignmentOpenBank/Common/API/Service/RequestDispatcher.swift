//
//  NetworkDispatcherFactory.swift
//  TestProject
//
//  Created by gustavo on 15/06/2019.
//  Copyright © 2019 ttg. All rights reserved.
//

import Alamofire

typealias APIRequestAdapterProtocol = RequestAdapter
typealias APIRequestRetrierProtocol = RequestRetrier

typealias RequestDispatcherHandler<T: Codable> = ((Swift.Result<T, RequestDispatcher.DispatchError>) -> Void)

let NSURLSuccessNoContent: Int = 204
let NSURLAppUpdateRequired: Int = 426

protocol RequestDispatcherProtocol {
    @discardableResult func dispatch<T: Codable>(request: Request, completion handler: @escaping RequestDispatcherHandler<T>) -> DispatchedRequest?
}

struct DispatchedRequest {
    fileprivate let request: Alamofire.Request
    
    func cancel() {
        request.cancel()
    }
}

class RequestDispatcher: RequestDispatcherProtocol {
    
    private let sessionManager: SessionManager = {
        let manager = SessionManager(configuration: URLSessionConfiguration.default)
        manager.session.configuration.urlCache = URLCache.shared
        return manager
    }()
    
    private struct Config {
        static let useSampleData: Bool = false
    }
    
    enum DispatchError: Error {
        case error(code: Int, message: [String: Any])
        case errorNoJson(code: Int, data: Data?)
        case parsing(message: String, data: Data) //Message is for debuggin purposes help find out which field failed
    }
    
    //When server responds with empty body, use this object
    final class EmptyBodyObject: Codable { }
    
    private var jsonDecoder: CustomJSONDecoder
    
    var customValidators: [(DataRequest) -> DataRequest]?
    
    init(jsonDecoder: CustomJSONDecoder = CustomJSONDecoder()) {
        self.jsonDecoder = jsonDecoder
    }
    
    @discardableResult
    func dispatch<T: Codable>(request: Request, completion handler: @escaping RequestDispatcherHandler<T>) -> DispatchedRequest? {
        
        if Config.useSampleData, let sample = request.service.sampleData {
            processResponse(sample, completion: handler)
            return nil
        }
        
        var mutRequest = URLRequest(url: request.url,
                                    cachePolicy: request.cachePolicy ?? .useProtocolCachePolicy,
                                    timeoutInterval: Constants.requestTimeout)
        mutRequest.allHTTPHeaderFields = request.headers
        mutRequest.httpBody = request.bodyData
        mutRequest.httpMethod = request.service.method.rawValue
        
        sessionManager.adapter = request.service.requestAdapter
        sessionManager.retrier = request.service.requestRetrier
        var alamoRequest = sessionManager.request(mutRequest).validate()
        if let customValidators = customValidators {
            customValidators.forEach { alamoRequest = $0(alamoRequest) }
        }
        alamoRequest = alamoRequest.responseData { (response) in
            print(response.request?.cURL ?? "")
            switch response.result {
            case .success(let data):
                if let statusCode = response.response?.statusCode, statusCode == NSURLSuccessNoContent {
                    handler(.failure(DispatchError.error(code: statusCode, message: [:])))
                    return
                }
                self.processResponse(data, completion: handler)
            case .failure(let error):
                let errorCode: Int = response.response?.statusCode ?? error.code
                
                guard errorCode != NSURLErrorCancelled else { return }
                
                if let data = response.data,
                    let bodyJson = try? JSONSerialization.jsonObject(with: data, options: []),
                    let body = bodyJson as? [String: Any] {
                    print("Error Body: \(String(data: data, encoding: .utf8) ??? ""))")
                    handler(.failure(DispatchError.error(code: errorCode, message: body)))
                } else {
                    handler(.failure(DispatchError.errorNoJson(code: errorCode, data: response.data)))
                }
            }
        }
        return DispatchedRequest(request: alamoRequest)
    }
    
    private func processResponse<T>(_ data: Data, completion handler: @escaping RequestDispatcherHandler<T>) {
        
        do {
            let model = try jsonDecoder.decode(T.self, from: data)
            handler(.success(model))
        } catch {
            print(error.localizedDescription)
            handler(.failure(.parsing(message: error.localizedDescription, data: data)))
        }
    }
}

class CustomJSONDecoder: JSONDecoder {
    
    override func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
        if T.self == RequestDispatcher.EmptyBodyObject.self,
            let obj = RequestDispatcher.EmptyBodyObject() as? T {
            return obj
        }
        return try super.decode(T.self, from: data)
    }
    
}
