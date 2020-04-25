//
//  HomeRouter.swift
//  AssignmentOpenBank
//
//  Created by pips on 19/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

import Foundation

protocol HomeRouterProtocol: BaseRouterProtocol {

    func navigateToStartTransaction(with bankAccount: BankModels.BankAccount)
    func navigateToTranferDetails(with transferDetails: BankModels.Transaction)
}

class HomeRouter: BaseRouter, HomeRouterProtocol {
    
    func navigateToStartTransaction(with bankAccount: BankModels.BankAccount) {
        
        viewController.navigationController?.pushViewController(SendMoneyBuilder.build(withAccount: bankAccount), animated: true)
    }
    
    func navigateToTranferDetails(with transferDetails: BankModels.Transaction) {
        
        viewController.navigationController?.pushViewController(TransferDetailsBuilder.build(withTrasferDetails: transferDetails), animated: true)
    }
}
