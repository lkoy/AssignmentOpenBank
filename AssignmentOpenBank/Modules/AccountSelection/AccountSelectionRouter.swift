//
//  AccountSelectionRouter.swift
//  AssignmentOpenBank
//
//  Created by pips on 29/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

import Foundation

protocol AccountSelectionRouterProtocol: BaseRouterProtocol {
    func navigateToRegistrationComplete()
    func navigateBack()
}

class AccountSelectionRouter: BaseRouter, AccountSelectionRouterProtocol {

    func navigateToRegistrationComplete() {
        
        navigationController?.setViewControllers([RegistrationCompleteBuilder.build()], animated: true)
    }
    
    func navigateBack() {
        
        viewController.navigationController?.popViewController(animated: true)
    }
}
