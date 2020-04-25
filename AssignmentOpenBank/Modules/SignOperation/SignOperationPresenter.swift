//
//  SignOperationPresenter.swift
//  AssignmentOpenBank
//
//  Created by pips on 16/02/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import Foundation

protocol SignOperationViewControllerProtocol: BaseViewControllerProtocol {

    func updateAuthUrl(with url: URL)
}

protocol SignOperationPresenterProtocol: BasePresenterProtocol {

    func prepareView()
    func getTokens(components: URLComponents)
    func topBarButtonPressed()
}

final class SignOperationPresenter<T: SignOperationViewControllerProtocol, U: SignOperationRouterProtocol>: BasePresenter<T, U> {

    private let iban: String
    private let bankAccount: BankModels.BankAccount
    private let concept: String
    private let urlString: String
    private let signOperationInteractor: SignOperationInteractorProtocol
    
    init(viewController: T, router: U, iban: String, bankAccount: BankModels.BankAccount, concept: String, urlString: String, signOperationInteractor: SignOperationInteractorProtocol) {
        
        self.iban = iban
        self.bankAccount = bankAccount
        self.concept = concept
        self.urlString = urlString
        self.signOperationInteractor = signOperationInteractor
        
        super.init(viewController: viewController, router: router)
    }
    
}

extension SignOperationPresenter: SignOperationPresenterProtocol {

    func prepareView() {
        
        let scope = "accounts balances"
        let escapedUrl = self.urlString.replacingOccurrences(of: scope, with: scope.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)
        
        guard let url = URL(string: escapedUrl) else {
            return
        }
        self.viewController.updateAuthUrl(with: url)
    }
    
    func getTokens(components: URLComponents) {
        self.signOperationInteractor.executePaymentWithComponents(components, iban: self.iban, bankAccount: self.bankAccount, concept: self.concept)
    }
    
    func topBarButtonPressed() {
        self.router.navigateBack()
    }
}

extension SignOperationPresenter: SignOperationInteractorCallbackProtocol {
    
    func signOperationSuccess() {
        
        router.navigateToHome()
    }
    
    func signOperationCancel() {
        
        router.navigateBack()
    }
    
    func signOperationFailure(with error: SignOperationError) {
        print("Fallou")
    }
}
