//
//  TransferDetailsBuilder.swift
//  AssignmentOpenBank
//
//  Created by pips on 05/04/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import Foundation
import UIKit.UIViewController

final class TransferDetailsBuilder: BaseBuilder {

    static func build(withTrasferDetails transfer: BankModels.Transaction) -> UIViewController {

        let viewController: TransferDetailsViewController = TransferDetailsViewController()
        let router: TransferDetailsRouter = TransferDetailsRouter(viewController: viewController)
        let presenter: TransferDetailsPresenter = TransferDetailsPresenter(viewController: viewController, router: router, transfer: transfer)
        viewController.presenter = presenter

        return viewController
    }

}
