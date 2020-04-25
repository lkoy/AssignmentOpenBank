//
//  AccountSelectionBuilder.swift
//  AssignmentOpenBank
//
//  Created by pips on 29/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

import Foundation
import UIKit.UIViewController

final class AccountSelectionBuilder: BaseBuilder {

    static func build(bank: BankModels.BankOption, userName: String) -> UIViewController {

        let viewController: AccountSelectionViewController = AccountSelectionViewController()
        let router: AccountSelectionRouter = AccountSelectionRouter(viewController: viewController)
        let getBankAccountsInteractor: GetBankAccountsInteractor = GetBankAccountsInteractor()
        let accountMapper = AccountSelectionMapper()
        let setPrimaryBankAccountInteractor: SetPrimaryBankAccountInteractor = SetPrimaryBankAccountInteractor()
        
        let presenter: AccountSelectionPresenter = AccountSelectionPresenter(viewController: viewController, router: router, bankOption: bank, userName: userName, getBankAccountInteractor: getBankAccountsInteractor, acountSelectionMapper: accountMapper, setPrimaryBankAccountInteractor: setPrimaryBankAccountInteractor)
        viewController.presenter = presenter
        getBankAccountsInteractor.presenter = presenter
        setPrimaryBankAccountInteractor.presenter = presenter

        return viewController
    }

}
