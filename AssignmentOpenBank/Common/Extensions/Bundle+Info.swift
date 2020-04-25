//
//  Bundle+Info.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 15/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

import Foundation

extension Bundle {
    
    static var identifier: String {
        return Bundle.main.bundleIdentifier ?? "no.bundle"
    }
    
    static var appVersion: String {
        return Bundle.main.applicationVersion
    }
    
    @objc open var applicationVersion: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0"
    }
    
    static var buildNumber: String {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "0.0"
    }
}
