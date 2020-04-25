//
//  SendMoneyBuilder.swift
//  AssignmentOpenBank
//
//  Created by pips on 27/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

import Foundation
import UIKit.UIViewController

final class SendMoneyBuilder: BaseBuilder {

    static func build(withAccount bankAccount: BankModels.BankAccount) -> UIViewController {

        let viewController: SendMoneyViewController = SendMoneyViewController()
        let router: SendMoneyRouter = SendMoneyRouter(viewController: viewController)
        let sendMoneyInteractor: SendMoneyInteractor = SendMoneyInteractor()
        
        let presenter: SendMoneyPresenter = SendMoneyPresenter(viewController: viewController, router: router, bankAccount: bankAccount, sendMoneyInteractor: sendMoneyInteractor)
        viewController.presenter = presenter
        sendMoneyInteractor.presenter = presenter

        return viewController
    }

}
