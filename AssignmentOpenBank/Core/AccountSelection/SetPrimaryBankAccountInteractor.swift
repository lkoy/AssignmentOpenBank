//
//  SetPrimaryBankAccountInteractor.swift
//  AssignmentOpenBank
//
//  Created by pips on 31/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

import Foundation
import Firebase

enum SetPrimaryBankAccountInteractorError {
    case storedFails
    case getUserError
    case updateUserError
    case accountIdError
    case showError
}

protocol SetPrimaryBankAccountInteractorProtocol: BaseInteractorProtocol {

    func storeBankAccount(_ account: BankModels.BankAccount)
}

protocol SetPrimaryBankAccountInteractorCallbackProtocol: BaseInteractorCallbackProtocol {

    func primaryAccountStored()
    func showError(type: SetPrimaryBankAccountInteractorError)
}

class SetPrimaryBankAccountInteractor: BaseInteractor {

    weak var presenter: SetPrimaryBankAccountInteractorCallbackProtocol!
    private let getSantanderBalanceWorker: GetSantanderBalanceWorkerAlias!
    private let getUserworker: GetUserLocalWorkerAlias!
    private let setUserworker: SetUserLocalWorkerAlias!

    init(getSantanderBalanceWorker: GetSantanderBalanceWorkerAlias = GetSantanderBalanceWorker(), userInfoWorker: GetUserLocalWorkerAlias = GetUserLocalWorker(), setUserWorker: SetUserLocalWorkerAlias = SetUserLocalWorker()) {
        
        self.getSantanderBalanceWorker = getSantanderBalanceWorker
        self.getUserworker = userInfoWorker
        self.setUserworker = setUserWorker
        super.init()
    }
    
    func persistBankAccount(bankAccount: BankModels.BankAccount) {
        
        self.getUserworker.execute() { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let userRegistered):
                self.updateUser(user: userRegistered, bankAccount: bankAccount)
            case .failure:
                self.presenter.showError(type: .getUserError)
            }
        }
    }
    
    func updateUser(user: BankModels.User, bankAccount: BankModels.BankAccount) {
        
        let bankAccounts = user.bankAccounts + [bankAccount]
        
        let userUpdated = BankModels.User(name: user.name,
                                          transactions: user.transactions,
                                          bankAccounts: bankAccounts)
        
        self.setUserworker.execute(input: userUpdated) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let userRegistered):
                self.presenter.primaryAccountStored()
            case .failure:
                self.presenter.showError(type: .updateUserError)
            }
        }
    }
}

extension SetPrimaryBankAccountInteractor: SetPrimaryBankAccountInteractorProtocol {

    func storeBankAccount(_ account: BankModels.BankAccount) {
            
        switch account.bank.kind {
        case .santander:
                
            if let accNumber = account.number, let accUser = account.accountUser {
                let params = GetSantanderBalanceParameters(accountNumber: accNumber, username: accUser)
                
                self.getSantanderBalanceWorker.execute(input: params) { [weak self] (result) in
                    guard let self = self else { return }
                    
                    switch result {
                    case .success(let balance):
                        var accountBank = account
                        accountBank.balance = balance.balance
                        self.persistBankAccount(bankAccount: accountBank)
                    case .failure(let error):
                        self.presenter.showError(type: .storedFails)
                    }
                }
            } else {
                self.presenter.showError(type: .accountIdError)
            }
        default:
            print("que pacha aqui")
        }
    }
}
