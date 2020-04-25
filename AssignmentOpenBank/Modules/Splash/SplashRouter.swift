//
//  SplashRouter.swift
//  AssignmentMoneyou
//
//  Created by ttg on 22/09/2019.
//  Copyright © 2019 ttg. All rights reserved.
//

import Foundation

protocol SplashRouterProtocol: BaseRouterProtocol {

    func navigateToUserRegistration()
    func navigateToBankAuth(bank: BankModels.BankOption)
    func navigateToHome()
    func navigateToAlert(title: String, message: String, primaryAction: ((DialogAction) -> Void)?)
}

class SplashRouter: BaseRouter, SplashRouterProtocol {
    
    func navigateToUserRegistration() {
        navigationController?.setViewControllers([UserBuilder.build()], animated: true)
    }
    
    func navigateToBankAuth(bank: BankModels.BankOption) {
        
        navigationController?.setViewControllers([BankAuthBuilder.build(bank: bank)], animated: true)
    }
    
    func navigateToHome() {
        navigationController?.setViewControllers([HomeBuilder.build()], animated: true)
    }
    
    func navigateToAlert(title: String, message: String, primaryAction: ((DialogAction) -> Void)?) {
        
        let dialog = DialogController(title: title,
                                      message: message,
                                      style: .alert,
                                      isDismissableWhenTappingOut: true)
        
        dialog.addAction(DialogAction(title: "Reintentar",
                                      style: .primary,
                                      handler: primaryAction))
        
        self.viewController.present(dialog, animated: true, completion: nil)
    }
}
