//
//  UserBuilder.swift
//  AssignmentOpenBank
//
//  Created by pips on 25/04/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import Foundation
import UIKit.UIViewController

final class UserBuilder: BaseBuilder {

    static func build() -> UIViewController {

        let viewController: UserViewController = UserViewController()
        let router: UserRouter = UserRouter(viewController: viewController)
        let userInteractor = UserInteractor()
        
        let presenter: UserPresenter = UserPresenter(viewController: viewController, router: router, userInteractor: userInteractor)
        viewController.presenter = presenter
        userInteractor.presenter = presenter

        return viewController
    }

}
