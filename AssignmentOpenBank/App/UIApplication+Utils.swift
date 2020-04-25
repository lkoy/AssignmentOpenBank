//
//  UIApplication+Utils.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 29/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

import UIKit.UIApplication

extension UIApplication {
    
    static func appDelegate() -> AppDelegate {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            return delegate
        } else {
            fatalError("UIApplication.shared.delegate isn't instance of AppDelegate")
        }
    }
    
    static var provider: Provider = {
        return appDelegate().provider
    }()
    
}
