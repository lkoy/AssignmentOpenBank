//
//  AcceptConsentsRouter.swift
//  AssignmentOpenBank
//
//  Created by pips on 15/02/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import Foundation

protocol AcceptConsentsRouterProtocol: BaseRouterProtocol {

    func navigateToSelectAccount(bankOption: BankModels.BankOption, userName: String)
    func navigateBack()
}

class AcceptConsentsRouter: BaseRouter, AcceptConsentsRouterProtocol {

    func navigateToSelectAccount(bankOption: BankModels.BankOption, userName: String) {
        
        viewController.navigationController?.pushViewController(AccountSelectionBuilder.build(bank: bankOption, userName: userName), animated: true)
    }
    
    func navigateBack() {
        
        viewController.navigationController?.popViewController(animated: true)
    }
}
