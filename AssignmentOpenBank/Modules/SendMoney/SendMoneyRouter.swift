//
//  SendMoneyRouter.swift
//  AssignmentOpenBank
//
//  Created by pips on 27/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

import Foundation

protocol SendMoneyRouterProtocol: BaseRouterProtocol {

    func navigateToHome()
    func navigateToSignOperation(toIban iban: String, bankAccount: BankModels.BankAccount, concept: String, urlString: String)
    func navigateBack()
}

class SendMoneyRouter: BaseRouter, SendMoneyRouterProtocol {

    func navigateToHome() {
        navigationController?.setViewControllers([HomeBuilder.build()], animated: true)
    }
    
    func navigateToSignOperation(toIban iban: String, bankAccount: BankModels.BankAccount, concept: String, urlString: String) {
        navigationController?.pushViewController(SignOperationBuilder.build(withAccount: iban, bankAccount: bankAccount, concept: concept, urlString: urlString), animated: true)
    }
    
    func navigateBack() {
        
        viewController.navigationController?.popViewController(animated: true)
    }
}
