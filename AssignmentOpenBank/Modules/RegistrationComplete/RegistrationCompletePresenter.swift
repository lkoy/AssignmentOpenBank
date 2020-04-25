//
//  RegistrationCompletePresenter.swift
//  AssignmentOpenBank
//
//  Created by pips on 16/04/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import Foundation

protocol RegistrationCompleteViewControllerProtocol: BaseViewControllerProtocol {

}

protocol RegistrationCompletePresenterProtocol: BasePresenterProtocol {

    func prepareView()
    func continuePresed()
}

final class RegistrationCompletePresenter<T: RegistrationCompleteViewControllerProtocol, U: RegistrationCompleteRouterProtocol>: BasePresenter<T, U> {

    override init(viewController: T, router: U) {
        super.init(viewController: viewController, router: router)
    }
    
}

extension RegistrationCompletePresenter: RegistrationCompletePresenterProtocol {
    
    func prepareView() {
        
    }
    
    func continuePresed() {
        
        self.router.navigateToHome()
    }
}
