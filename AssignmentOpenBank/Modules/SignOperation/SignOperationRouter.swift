//
//  SignOperationRouter.swift
//  AssignmentOpenBank
//
//  Created by pips on 16/02/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import Foundation

protocol SignOperationRouterProtocol: BaseRouterProtocol {
    
    func navigateToHome()
    func navigateBack()
}

class SignOperationRouter: BaseRouter, SignOperationRouterProtocol {
    
    func navigateToHome() {
        navigationController?.setViewControllers([HomeBuilder.build()], animated: true)
    }
    
    func navigateBack() {
        
        viewController.navigationController?.popViewController(animated: true)
    }
}
