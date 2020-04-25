//
//  File.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 17/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

import Foundation

extension URLComponents {
    
    func queryItem(with name: String) -> URLQueryItem? {
        return self.queryItems?.first(where: { $0.name == name })
    }
    
    func valueOfQueryItem(with name: String) -> String? {
        return queryItem(with: name)?.value
    }
    
}
