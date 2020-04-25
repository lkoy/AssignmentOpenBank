//
//  SantanderRequestDispatcher.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 28/01/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import Foundation
import Alamofire

class SantanderRequestDispatcher: RequestDispatcher {
    
    @discardableResult
    override func dispatch<T>(request: Request, completion handler: @escaping ((Swift.Result<T, RequestDispatcher.DispatchError>) -> Void)) -> DispatchedRequest? where T: Decodable, T: Encodable {
        
        var newRequest = request
        
        return super.dispatch(request: newRequest, completion: handler)
        
    }
}
