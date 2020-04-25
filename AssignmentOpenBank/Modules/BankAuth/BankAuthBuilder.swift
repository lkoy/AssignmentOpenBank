//
//  BankAuthBuilder.swift
//  AssignmentOpenBank
//
//  Created by pips on 14/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

import Foundation
import UIKit.UIViewController

final class BankAuthBuilder: BaseBuilder {

    static func build(bank: BankModels.BankOption) -> UIViewController {

        let viewController: BankAuthViewController = BankAuthViewController()
        let router: BankAuthRouter = BankAuthRouter(viewController: viewController)
        let bankAuthInteractor: BankAuthInteractor = BankAuthInteractor()
        let getBankTokensInteractor: GetBankTokensInteractor = GetBankTokensInteractor()
        
        let presenter: BankAuthPresenter = BankAuthPresenter(viewController: viewController, router: router, bankOption: bank, bankAuthInteractor: bankAuthInteractor, getBankTokensInteractor: getBankTokensInteractor)
        viewController.presenter = presenter
        bankAuthInteractor.presenter = presenter
        getBankTokensInteractor.presenter = presenter

        return viewController
    }

}
