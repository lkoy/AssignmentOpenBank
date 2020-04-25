//
//  SendMoneyInteractor.swift
//  AssignmentOpenBank
//
//  Created by pips on 06/01/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import Foundation

protocol SendMoneyInteractorProtocol: BaseInteractorProtocol {

    func sendMoney(to iban: String, from bankAccount: BankModels.BankAccount, value: Decimal, concept: String)
}

protocol SendMoneyInteractorCallbackProtocol: BaseInteractorCallbackProtocol {

    func transactionFinished()
    func signOperationNeeded(iban: String, url: String, concept: String)
}

class SendMoneyInteractor: BaseInteractor {

    weak var presenter: SendMoneyInteractorCallbackProtocol!
    private let sendMoneySantanderWorker: SendMoneySantanderWorkerAlias
    private let refreshSantanderTokensWorker: RefreshSantanderTokensWorkerAlias
    
    private let getUserLocalWorker: GetUserLocalWorkerAlias
    private let setUserLocalWorker: SetUserLocalWorkerAlias
    
    private var destinationIban: String?
    private var bankAccount: BankModels.BankAccount?

    init(sendMoneySantanderWorker: SendMoneySantanderWorkerAlias = SendMoneySantanderWorker(), userLocalWorker: GetUserLocalWorkerAlias = GetUserLocalWorker(), setUserLocalWorker: SetUserLocalWorkerAlias = SetUserLocalWorker(), refreshSantanderTokensWorker: RefreshSantanderTokensWorkerAlias = RefreshSantanderTokensWorker()) {
        
        self.sendMoneySantanderWorker = sendMoneySantanderWorker
        
        self.getUserLocalWorker = userLocalWorker
        self.setUserLocalWorker = setUserLocalWorker
        self.refreshSantanderTokensWorker = refreshSantanderTokensWorker
        super.init()
    }
    
    private func refreshSantanderToken(iban: String, from bankAccount: BankModels.BankAccount, value: Decimal, concept: String) {
        
        let input = RefreshSantanderTokensParameter(userName: bankAccount.accountUser ?? "")
//        let input = RefreshSantanderTokensParameter(userName: "e2cd79ea-6445-4973-a92d-c52f7d35ee1f")
        
        self.refreshSantanderTokensWorker.execute(input: input) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success:
                self.sendMoney(to: iban, from: bankAccount, value: value, concept: concept)
            case .failure:
                print("error")
            }
        }
    }
}

extension SendMoneyInteractor: SendMoneyInteractorProtocol {

    func sendMoney(to iban: String, from bankAccount: BankModels.BankAccount, value: Decimal, concept: String) {
        
        self.destinationIban = iban
        self.bankAccount = bankAccount
        
        switch bankAccount.bank.kind {
        case .santander:
            let parameters = SendMoneySantanderParameters(redirectUri: provider.configuration.santander.redirectUri,
                                                          accountFrom: bankAccount.number ?? "",
                                                          residenceCountry: "ES",
                                                          accountName: "Gateway Payments ES euGBHm",
                                                          accountTo: iban,
                                                          currencyTo: "EUR",
                                                          amount: value,
                                                          currency: "EUR",
                                                          spendingPolicy: "SHARED",
                                                          destinationCountry: "ES",
                                                          concept: concept,
                                                          type: "sepa_credit_transfer",
                                                          inmediately: true,
                                                          userName: bankAccount.accountUser ?? "")
            
            self.sendMoneySantanderWorker.execute(input: parameters) { [weak self] (result) in
                guard let self = self else { return }
                
                switch result {
                case .success(let url):
                    self.presenter.signOperationNeeded(iban: iban, url: url, concept: concept)
                case .failure(let error):
                    switch error {
                    case .accessDeniedError:
                        self.refreshSantanderToken(iban: iban, from: bankAccount, value: value, concept: concept)
                    default:
                        print("Santander payment error")
                    }
                }
            }
        default:
            print("error")
        }
    }
}
