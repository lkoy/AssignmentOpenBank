//
//  SplashBuilder.swift
//  AssignmentMoneyou
//
//  Created by ttg on 22/09/2019.
//  Copyright © 2019 ttg. All rights reserved.
//

import Foundation
import UIKit.UIViewController

final class SplashBuilder: BaseBuilder {

    static func build() -> UIViewController {

        let viewController: SplashViewController = SplashViewController()
        let router: SplashRouter = SplashRouter(viewController: viewController)
        
        let checkStateInteractor = SplashInteractor()
        let presenter: SplashPresenter = SplashPresenter(viewController: viewController,
                                                         router: router,
                                                         checkStateInteractor: checkStateInteractor)
        viewController.presenter = presenter
        checkStateInteractor.presenter = presenter

        return viewController
    }
}
