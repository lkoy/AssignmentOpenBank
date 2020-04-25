//
//  BankAuthRouter.swift
//  AssignmentOpenBank
//
//  Created by pips on 14/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

import Foundation

protocol BankAuthRouterProtocol: BaseRouterProtocol {

    func navigateToSelectAccount(bankOption: BankModels.BankOption, userName: String)
    func navigateToAcceptConsents(bankOption: BankModels.BankOption, userName: String, urlString: String)
    func navigateBack()
}

class BankAuthRouter: BaseRouter, BankAuthRouterProtocol {

    func navigateToSelectAccount(bankOption: BankModels.BankOption, userName: String) {
        
        viewController.navigationController?.pushViewController(AccountSelectionBuilder.build(bank: bankOption, userName: userName), animated: true)
    }
    
    func navigateToAcceptConsents(bankOption: BankModels.BankOption, userName: String, urlString: String) {
        
        viewController.navigationController?.pushViewController(AcceptConsentsBuilder.build(bank: bankOption, userName: userName, urlString: urlString), animated: true)
    }
    
    func navigateBack() {
        
        viewController.navigationController?.popViewController(animated: true)
    }
}
