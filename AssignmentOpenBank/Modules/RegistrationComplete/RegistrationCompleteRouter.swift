//
//  RegistrationCompleteRouter.swift
//  AssignmentOpenBank
//
//  Created by pips on 16/04/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import Foundation

protocol RegistrationCompleteRouterProtocol: BaseRouterProtocol {

    func navigateToHome()
}

class RegistrationCompleteRouter: BaseRouter, RegistrationCompleteRouterProtocol {

    func navigateToHome() {
        
        navigationController?.setViewControllers([HomeBuilder.build()], animated: true)
    }
}
