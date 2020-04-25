//
//  UserRouter.swift
//  AssignmentOpenBank
//
//  Created by pips on 25/04/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import Foundation

protocol UserRouterProtocol: BaseRouterProtocol {

    func navigateToBankAuth(bank: BankModels.BankOption)
}

class UserRouter: BaseRouter, UserRouterProtocol {

    func navigateToBankAuth(bank: BankModels.BankOption) {
        
        viewController.navigationController?.pushViewController(BankAuthBuilder.build(bank: bank), animated: true)
    }
}
