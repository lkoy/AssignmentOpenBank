//
//  AcceptConsentsPresenter.swift
//  AssignmentOpenBank
//
//  Created by pips on 15/02/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import Foundation

protocol AcceptConsentsViewControllerProtocol: BaseViewControllerProtocol {

    func updateAuthUrl(with url: URL)
}

protocol AcceptConsentsPresenterProtocol: BasePresenterProtocol {

    func prepareView()
    func getTokens(components: URLComponents)
    func topBarButtonPressed()
}

final class AcceptConsentsPresenter<T: AcceptConsentsViewControllerProtocol, U: AcceptConsentsRouterProtocol>: BasePresenter<T, U> {

    private let bankOption: BankModels.BankOption
    private let userName: String
    private let urlString: String
    private let getBankTokensInteractor: GetBankServiceTokensInteractorProtocol
    
    init(viewController: T, router: U, bankOption: BankModels.BankOption, userName: String, urlString: String, getBankTokensInteractor: GetBankServiceTokensInteractorProtocol) {
        
        self.bankOption = bankOption
        self.userName = userName
        self.urlString = urlString
        self.getBankTokensInteractor = getBankTokensInteractor
        
        super.init(viewController: viewController, router: router)
    }
    
}

extension AcceptConsentsPresenter: AcceptConsentsPresenterProtocol {

    func prepareView() {
        
        let scope = "accounts balances"
        let escapedUrl = self.urlString.replacingOccurrences(of: scope, with: scope.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)
        
        guard let url = URL(string: escapedUrl) else {
            return
        }
        self.viewController.updateAuthUrl(with: url)
    }
    
    func getTokens(components: URLComponents) {
        self.getBankTokensInteractor.getTokenWithComponents(components, bank: bankOption, userName: userName)
    }
    
    func topBarButtonPressed() {
        self.router.navigateBack()
    }
}

extension AcceptConsentsPresenter: GetBankServiceTokensInteractorCallbackProtocol {
    
    func acceptConsentsSuccess(userName: String) {
        router.navigateToSelectAccount(bankOption: bankOption, userName: userName)
    }
    
    func acceptConsentsCancel() {
        router.navigateBack()
    }
    
    func acceptConsentsFailure(with error: GetBankServiceTokensError) {
        print("Fallou")
    }
}
