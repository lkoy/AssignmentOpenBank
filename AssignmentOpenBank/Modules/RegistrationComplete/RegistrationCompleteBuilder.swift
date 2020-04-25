//
//  RegistrationCompleteBuilder.swift
//  AssignmentOpenBank
//
//  Created by pips on 16/04/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import Foundation
import UIKit.UIViewController

final class RegistrationCompleteBuilder: BaseBuilder {

    static func build() -> UIViewController {

        let viewController: RegistrationCompleteViewController = RegistrationCompleteViewController()
        let router: RegistrationCompleteRouter = RegistrationCompleteRouter(viewController: viewController)
        let presenter: RegistrationCompletePresenter = RegistrationCompletePresenter(viewController: viewController, router: router)
        viewController.presenter = presenter

        return viewController
    }

}
