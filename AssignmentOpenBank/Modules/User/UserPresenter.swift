//
//  UserPresenter.swift
//  AssignmentOpenBank
//
//  Created by pips on 25/04/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import Foundation

protocol UserViewControllerProtocol: BaseViewControllerProtocol {

    func show(_ viewModel: User.ViewModel)
    func showLoadingState()
    func hideLoadingState()
}

protocol UserPresenterProtocol: BasePresenterProtocol {

    func prepareView()
    func nameEntered(_ text: String?)
    func createUser(name: String?)
}

final class UserPresenter<T: UserViewControllerProtocol, U: UserRouterProtocol>: BasePresenter<T, U> {

    private let userInteractor: UserInteractorProtocol
    
    init(viewController: T, router: U, userInteractor: UserInteractorProtocol) {
        
        self.userInteractor = userInteractor
        super.init(viewController: viewController, router: router)
    }
    
}

extension UserPresenter: UserPresenterProtocol {

    func prepareView() {
        
    }
    
    func nameEntered(_ text: String?) {

        let enabledButton = !(text?.isEmpty ?? true)
        let viewModel = User.ViewModel(nameFieldText: text,
                                       buttonEnabled: enabledButton)
        viewController.show(viewModel)
    }
    
    func createUser(name: String?) {
        
        viewController.showLoadingState()
        if let username = name {
            userInteractor.registerUser(name: username)
        }
    }
    
//    func continuePresed() {
//
//        self.userInteractor.getBankOptionsAvailable(config: provider.configuration)
//    }
}

extension UserPresenter: UserInteractorCallbackProtocol {
    
    func bankOption(value: BankModels.BankOption) {
        
        self.router.navigateToBankAuth(bank: value)
    }
    
    func showError(type: UserInteractorError) {
        print("")
    }
}
