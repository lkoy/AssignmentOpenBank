//
//  SignOperationBuilder.swift
//  AssignmentOpenBank
//
//  Created by pips on 16/02/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import Foundation
import UIKit.UIViewController

final class SignOperationBuilder: BaseBuilder {

    static func build(withAccount iban: String, bankAccount: BankModels.BankAccount, concept: String, urlString: String) -> UIViewController {

        let viewController: SignOperationViewController = SignOperationViewController()
        let router: SignOperationRouter = SignOperationRouter(viewController: viewController)
        let signOperationInteractor: SignOperationInteractor = SignOperationInteractor()
        
        let presenter: SignOperationPresenter = SignOperationPresenter(viewController: viewController, router: router, iban: iban, bankAccount: bankAccount, concept: concept, urlString: urlString, signOperationInteractor: signOperationInteractor)
        
        viewController.presenter = presenter
        signOperationInteractor.presenter = presenter

        return viewController
    }

}
