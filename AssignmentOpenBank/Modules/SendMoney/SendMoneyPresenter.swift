//
//  SendMoneyPresenter.swift
//  AssignmentOpenBank
//
//  Created by pips on 27/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

import Foundation

protocol SendMoneyViewControllerProtocol: BaseViewControllerProtocol {

    func show(_ viewModel: SendMoney.ViewModel)
    func showLoadingState()
    func hideLoadingState()
}

protocol SendMoneyPresenterProtocol: BasePresenterProtocol {

    func prepareView()
    func sendMoney(iban: String?, amount: String?, concept: String?)
    func close()
}

final class SendMoneyPresenter<T: SendMoneyViewControllerProtocol, U: SendMoneyRouterProtocol>: BasePresenter<T, U> {

    private let bankAccount: BankModels.BankAccount
    private let sendMoneyInteractor: SendMoneyInteractorProtocol
    
    init(viewController: T, router: U, bankAccount: BankModels.BankAccount, sendMoneyInteractor: SendMoneyInteractorProtocol) {
        
        self.bankAccount = bankAccount
        self.sendMoneyInteractor = sendMoneyInteractor
        super.init(viewController: viewController, router: router)
    }
    
}

extension SendMoneyPresenter: SendMoneyPresenterProtocol {

    func prepareView() {
        self.viewController.show(SendMoney.ViewModel(name: "",
                            phone: "",
                            imageUrl: ""))
        
    }
    
    func sendMoney(iban: String?, amount: String?, concept: String?) {
        
        if let amountQuantity = amount, let conceptMessage = concept, let ibanUn = iban {
            
            self.sendMoneyInteractor.sendMoney(to: ibanUn, from: self.bankAccount, value: Decimal(string: amountQuantity) ?? 0, concept: conceptMessage)
            self.viewController.showLoadingState()
        }
    }
    
    func close() {
        
        router.navigateBack()
    }
}

extension SendMoneyPresenter: SendMoneyInteractorCallbackProtocol {
    
    func transactionFinished() {
        
        self.viewController.hideLoadingState()
        router.navigateToHome()
    }
    
    func signOperationNeeded(iban: String, url: String, concept: String) {
        
        self.viewController.hideLoadingState()
        router.navigateToSignOperation(toIban: iban, bankAccount: self.bankAccount, concept: concept, urlString: url)
    }
}
