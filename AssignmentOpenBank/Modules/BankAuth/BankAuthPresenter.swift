//
//  BankAuthPresenter.swift
//  AssignmentOpenBank
//
//  Created by pips on 14/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

import Foundation

protocol BankAuthViewControllerProtocol: BaseViewControllerProtocol {

    func updateAuthUrl(with url: URL)
}

protocol BankAuthPresenterProtocol: BasePresenterProtocol {

    func prepareView()
    func getTokens(components: URLComponents)
    func topBarButtonPressed()
}

final class BankAuthPresenter<T: BankAuthViewControllerProtocol, U: BankAuthRouterProtocol>: BasePresenter<T, U> {

    private let bankOption: BankModels.BankOption
    private let bankAuthInteractor: BankAuthInteractorProtocol
    private let getBankTokensInteractor: GetBankTokensInteractorProtocol
    
    init(viewController: T, router: U, bankOption: BankModels.BankOption, bankAuthInteractor: BankAuthInteractorProtocol, getBankTokensInteractor: GetBankTokensInteractorProtocol) {
        
        self.bankOption = bankOption
        self.bankAuthInteractor = bankAuthInteractor
        self.getBankTokensInteractor = getBankTokensInteractor
        super.init(viewController: viewController, router: router)
    }
    
}

extension BankAuthPresenter: BankAuthPresenterProtocol {
    
    func prepareView() {
        self.bankAuthInteractor.getAuthUrl(for: bankOption)
    }
    
    func getTokens(components: URLComponents) {
        self.getBankTokensInteractor.getTokenWithComponents(components, bank: bankOption)
    }
    
    func topBarButtonPressed() {
        self.router.navigateBack()
    }
}

extension BankAuthPresenter: GetBankTokensInteractorCallbackProtocol {
    
    func signInSuccess(userName: String) {
        router.navigateToSelectAccount(bankOption: bankOption, userName: userName)
    }
    
    func signInFailure(with error: GetBankTokensError) {
        print("Fallou")
    }
    
    func acceptConsentsNeeded(with url: String, userName: String) {
        
        router.navigateToAcceptConsents(bankOption: bankOption, userName: userName, urlString: url)
    }
}

extension BankAuthPresenter: BankAuthInteractorCallbackProtocol {
    
    func bankAuthUrl(_ url: URL) {
        self.viewController.updateAuthUrl(with: url)
    }
}
