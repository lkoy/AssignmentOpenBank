//
//  SantanderPaymentsApiRequestRetrier.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 15/02/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import Alamofire

class SantanderPaymentsApiRequestRetrier: APIRequestRetrierProtocol {
    
    static let global: SantanderPaymentsApiRequestRetrier = SantanderPaymentsApiRequestRetrier()
    
    private typealias RefreshCompletion = (_ succeeded: Bool, _ accessToken: String?, _ refreshToken: String?, _ expirationTime: Int?) -> Void
    
    private let sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.urlCache = nil
        return SessionManager(configuration: configuration)
    }()
    
    private let lock = NSLock()
    private var santanderKeychain: CodableKeychain<SantanderModels.Token>
    private var isRefreshing = false
    private var requestsToRetry: [RequestRetryCompletion] = []
    private var retriedRequests: [String: Int] = [:]
    private var maxNumberOfRetries: Int = SantanderNetworkService.Config.maxNumberOfRetries
    private var user: String?
    
    // MARK: - Initialization
    
    public init(withSantanderKeychain santanderKeychain: CodableKeychain<SantanderModels.Token> = SantanderPreAuthTokenKeychainBuilder.build()) {
        self.santanderKeychain = santanderKeychain
    }
    
    // MARK: - RequestRetrier
    
    func should(_ manager: SessionManager, retry request: Alamofire.Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        guard let url = request.request?.url?.absoluteString else {
            completion(false, 0.0)
            return
        }
        
        self.user = request.request?.value(forHTTPHeaderField: "x-account-user")
        
        lock.lock() ; defer { lock.unlock() }
        
        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
            
            if let retryCount = retriedRequests[url], retryCount >= maxNumberOfRetries {
                removeCachedUrlRequest(url: url)
                self.requestsToRetry.removeAll()
                completion(false, 0.0)
                return
            } else if let retryCount = retriedRequests[url] {
                retriedRequests[url] = retryCount + 1
            } else {
                retriedRequests[url] = 1
            }
            
            requestsToRetry.append(completion)
            
            refreshTokens { [weak self] succeeded, accessToken, refreshToken, expirationTime in
                guard let self = self else { return }
                
                if let accessToken = accessToken,
                    let refreshToken = refreshToken {
                    try? self.santanderKeychain.store(codable: SantanderModels.Token(accessToken: accessToken, refreshToken: refreshToken), user: self.user)
                }
                
                self.requestsToRetry.forEach { $0(succeeded, 0.0) }
                self.requestsToRetry.removeAll()
                self.retriedRequests.removeAll()
            }
        } else {
            completion(false, 0.0)
        }
    }
    
    // MARK: - Private - Refresh Tokens
    
    private func refreshTokens(completion: @escaping RefreshCompletion) {
        guard !isRefreshing, let santanderRefreshToken = try? santanderKeychain.fetch(user: self.user).refreshToken else {
            completion(false, nil, nil, nil)
            return
        }
        
        isRefreshing = true
        
        let authorisation = SantanderNetworkService.Config.clientId + ":" + SantanderNetworkService.Config.clientSecret
        let utf8str = authorisation.data(using: .utf8)
        var authValue = ""
        if let base64Encoded = utf8str?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0)) {
            authValue = "Basic " + base64Encoded
        } else {
            authValue = "Basic " + authorisation
        }
        
        let headers = ["X-IBM-Client-Secret": SantanderNetworkService.Config.clientSecret,
                       "X-IBM-Client-Id": SantanderNetworkService.Config.clientId,
                       "Authorization": authValue,
                       "accept": "application/json",
                       "Cache-Control": "no-cache, no-store"]
        
        let params: [Parameter] = [("grant_type", "refresh_token"), ("refresh_token", santanderRefreshToken)]
        
        let request = Request.init(service: SantanderNetworkService.Auth.refreshAccessToken, parametersBody: params, headers: headers)
        
        var mutRequest = URLRequest(url: request.url,
                                    cachePolicy: request.cachePolicy ?? .useProtocolCachePolicy,
                                    timeoutInterval: Constants.requestTimeout)
        mutRequest.allHTTPHeaderFields = request.headers
        mutRequest.httpBody = request.bodyData
        mutRequest.httpMethod = request.service.method.rawValue
        
        sessionManager.request(mutRequest)
            .responseJSON { [weak self] response in
                
                guard let self = self else { return }
                
                if let json = response.result.value as? [String: Any],
                    let accessToken = json["access_token"] as? String,
                    let expiresIn = json["expires_in"] as? Int {
                    completion(true, accessToken, santanderRefreshToken, expiresIn)
                } else {
                    completion(false, nil, nil, nil)
                }
                self.isRefreshing = false
        }
    }
    
    // MARK: - Private - Remove retried requests
    
    private func removeCachedUrlRequest(url: String?) {
        guard let url = url else {
            return
        }
        retriedRequests.removeValue(forKey: url)
    }
}
