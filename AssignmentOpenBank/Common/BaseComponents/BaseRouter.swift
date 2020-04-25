//
//  BaseRouter.swift
//  AssignmentMoneyou
//
//  Created by Iglesias, Gustavo on 22/09/2019.
//  Copyright © 2019 ttg. All rights reserved.
//

import UIKit.UIViewController

public protocol BaseRouterProtocol: class { }

open class BaseRouter {
    
    unowned let viewController: UIViewController
    
    internal var navigationController: UINavigationController? {
        return viewController.navigationController
    }
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
}

extension BaseRouter: BaseRouterProtocol {
    
    private func present(viewController: UIViewController, completion: (() -> Void)? = nil) {
        if let navController = navigationController {
            navController.present(viewController, animated: true, completion: completion)
        } else {
            self.viewController.present(viewController, animated: true, completion: completion)
        }
    }
}

extension BaseRouter {
    
    final func cleanStackAndAppend(_ controller: UIViewController) -> [UIViewController] {
        var stack = [UIViewController]()
        if let viewController = viewController.navigationController?.viewControllers.first {
            stack.append(viewController)
        }
        stack.append(controller)
        return stack
    }
}
