//
//  HomeBuilder.swift
//  AssignmentOpenBank
//
//  Created by pips on 19/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

import Foundation
import UIKit.UIViewController

final class HomeBuilder: BaseBuilder {

    static func build() -> UIViewController {

        let viewController: HomeViewController = HomeViewController()
        let router: HomeRouter = HomeRouter(viewController: viewController)
        let homeInformationInteractor = GetHomeInformationInteractor()
        let homeMapper = HomeMapper()
        
        let presenter: HomePresenter = HomePresenter(viewController: viewController, router: router, getHomeInformationInteractor: homeInformationInteractor, homeMapper: homeMapper)
        viewController.presenter = presenter
        homeInformationInteractor.presenter = presenter

        return viewController
    }

}
