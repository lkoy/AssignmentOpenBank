//
//  BasePresenter.swift
//  AssignmentMoneyou
//
//  Created by Iglesias, Gustavo on 22/09/2019.
//  Copyright © 2019 ttg. All rights reserved.
//

import UIKit.UIApplication

public protocol BaseViewControllerProtocol: class { }

public extension BaseViewControllerProtocol { }

public protocol BasePresenterProtocol: class { }

public class BasePresenter<T: BaseViewControllerProtocol, U: BaseRouterProtocol>: BasePresenterProtocol {
    
    unowned let viewController: T
    let router: U
    
    init(viewController: T,
         router: U) {
        self.viewController = viewController
        self.router = router
    }
    
    deinit {
        
    }
}
