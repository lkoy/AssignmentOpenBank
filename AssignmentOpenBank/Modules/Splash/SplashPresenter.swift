//
//  SplashPresenter.swift
//  AssignmentMoneyou
//
//  Created by ttg on 22/09/2019.
//  Copyright © 2019 ttg. All rights reserved.
//

import Foundation

protocol SplashViewControllerProtocol: BaseViewControllerProtocol {

}

protocol SplashPresenterProtocol: BasePresenterProtocol {
    
    func checkRegistrationStatus()
}

final class SplashPresenter<T: SplashViewControllerProtocol, U: SplashRouterProtocol>: BasePresenter<T, U> {
    
    private let checkStateInteractor: SplashInteractorProtocol

    init(viewController: T, router: U, checkStateInteractor: SplashInteractorProtocol) {
        
        self.checkStateInteractor = checkStateInteractor
        super.init(viewController: viewController, router: router)
    }
    
}

extension SplashPresenter: SplashPresenterProtocol {
    
    func checkRegistrationStatus() {
        registrationStatus()
    }
}

extension SplashPresenter {
    
    private func registrationStatus() {
        checkStateInteractor.getState()
    }
}

extension SplashPresenter: SplashInteractorCallbackProtocol {
    
    func showError(type: SplashInteractorError) {
        
        self.router.navigateToAlert(title: "Error",
                                    message: "Vuelve a intentarlo",
                                    primaryAction: { [weak self] (_) in
                                        guard let self = self else { return }
                                        self.checkRegistrationStatus()
                                    })
    }
    
    func userRegistered() {
        
        router.navigateToHome()
    }
    
    func bankOption(value: BankModels.BankOption) {
        
        self.router.navigateToBankAuth(bank: value)
    }
    
    func firstTimeUser() {
        
        router.navigateToUserRegistration()
    }
}
