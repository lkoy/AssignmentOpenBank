//
//  Provider.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 29/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

import UIKit.UIApplication

protocol Provider {
    var genericCoreData: CoreDataManageable { get }
    var configuration: Configuration { get }
}

var provider: Provider { return UIApplication.provider }

class AppProvider: Provider {
    
    lazy var genericCoreData: CoreDataManageable = {
        return CoreDataManager(withContainerName: CoreDataContainerNames.generic)
    }()
    
    var configuration: Configuration {
        return ConfigurationBuilder.build()
    }
}
