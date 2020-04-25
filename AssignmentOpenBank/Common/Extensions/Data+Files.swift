//
//  Data+Files.swift
//  AssignmentMoneyou
//
//  Created by Iglesias, Gustavo on 23/09/2019.
//  Copyright © 2019 ttg. All rights reserved.
//

import Foundation

extension Data {
    
    static func loadJSON(with fileName: String) -> Data? {
        
        guard let filePath = Bundle.main.path(forResource: fileName, ofType: "json") else {
            return nil
        }
        return NSData.init(contentsOfFile: filePath) as Data?
    }
}
