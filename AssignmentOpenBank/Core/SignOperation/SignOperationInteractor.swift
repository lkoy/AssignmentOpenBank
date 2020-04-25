//
//  SignOperationInteractor.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 16/02/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import Foundation

enum SignOperationError: Error {
    case getTokenError
    case executePaymentError
    case codeInvalidError
    case signatureInvalidError
    case unknownError
}

protocol SignOperationInteractorProtocol: BaseInteractorProtocol {
    func executePaymentWithComponents(_ components: URLComponents, iban: String, bankAccount: BankModels.BankAccount, concept: String)
}

protocol SignOperationInteractorCallbackProtocol: BaseInteractorCallbackProtocol {
    func signOperationSuccess()
    func signOperationCancel()
    func signOperationFailure(with error: SignOperationError)
}

class SignOperationInteractor: BaseInteractor {

    weak var presenter: SignOperationInteractorCallbackProtocol!
    private let getTokenWorker: GetSantanderTokensWorkerAlias
    private let paymentExecutionWorker: PaymentExecutionSantanderWorkerAlias
    
    private let getUserLocalWorker: GetUserLocalWorkerAlias
    
    private var destinationIban: String?
    private var bankAccount: BankModels.BankAccount?
    private var concept: String?

    init(withGetSantanderTokensWorker tokenWorker: GetSantanderTokensWorkerAlias = GetSantanderTokensWorker(), paymentExecutionWorker: PaymentExecutionSantanderWorkerAlias = PaymentExecutionSantanderWorker(), userLocalWorker: GetUserLocalWorkerAlias = GetUserLocalWorker()) {
        
        self.getTokenWorker = tokenWorker
        self.paymentExecutionWorker = paymentExecutionWorker
        self.getUserLocalWorker = userLocalWorker
        super.init()
    }
    
    private func registerTransaction(transaction: BankModels.Transaction) {
        
        self.getUserLocalWorker.execute{ [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let user):
                self.presenter.signOperationSuccess()
            case .failure(let error):
                print("error")
            }
        }
    }
}

extension SignOperationInteractor: SignOperationInteractorProtocol {

    func executePaymentWithComponents(_ components: URLComponents, iban: String, bankAccount: BankModels.BankAccount, concept: String) {
        
        if let _ = components.valueOfQueryItem(with: "authorize_error") {
                presenter.signOperationCancel()
        } else {
            guard let code = components.valueOfQueryItem(with: "code") else {
                presenter.signOperationFailure(with: .codeInvalidError)
                return
            }
            guard let signature = components.valueOfQueryItem(with: "SOS-JWT-TOKEN") else {
                presenter.signOperationFailure(with: .signatureInvalidError)
                return
            }
            
            self.destinationIban = iban
            self.bankAccount = bankAccount
            self.concept = concept
            
            getTokenWorker.execute(input: GetSantanderTokensParameter(code: code)) { [weak self] (result) in
                guard let self = self else { return }
                
                switch result {
                case .success(let tokens):
                    let params = PaymentExecutionSantanderParameters(accesToken: tokens.accessToken, signatureToken: signature, userName: bankAccount.accountUser ?? "")
                    self.paymentExecutionWorker.execute(input: params) { [weak self] (result) in
                        guard let self = self else { return }
                        
                        switch result {
                        case .success(let transaction):
                            self.registerTransaction(transaction: transaction)
                        case .failure:
                            self.presenter.signOperationFailure(with: .executePaymentError)
                        }
                    }
                case .failure(let error):
                    switch error {
                    case .getTokenError:
                        self.presenter.signOperationFailure(with: .getTokenError)
                    }
                }
            }
        }
    }
}
