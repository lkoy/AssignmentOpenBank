//
//  AcceptConsentsBuilder.swift
//  AssignmentOpenBank
//
//  Created by pips on 15/02/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import Foundation
import UIKit.UIViewController

final class AcceptConsentsBuilder: BaseBuilder {

    static func build(bank: BankModels.BankOption, userName: String, urlString: String) -> UIViewController {

        let viewController: AcceptConsentsViewController = AcceptConsentsViewController()
        let router: AcceptConsentsRouter = AcceptConsentsRouter(viewController: viewController)
        let getBankTokensInteractor: GetBankServiceTokensInteractor = GetBankServiceTokensInteractor()
        
        let presenter: AcceptConsentsPresenter = AcceptConsentsPresenter(viewController: viewController, router: router, bankOption: bank, userName: userName, urlString: urlString, getBankTokensInteractor: getBankTokensInteractor)
        
        viewController.presenter = presenter
        getBankTokensInteractor.presenter = presenter

        return viewController
    }

}
