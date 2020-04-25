//
//  GetBankAccountsInteractor.swift
//  AssignmentOpenBank
//
//  Created by pips on 29/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

import Foundation

protocol GetBankAccountsInteractorProtocol: BaseInteractorProtocol {

    func getBankAccounts(bank: BankModels.BankOption, userName: String)
}

protocol GetBankAccountsInteractorCallbackProtocol: BaseInteractorCallbackProtocol {

    func updateBankAccounts(_ bankAccounts: [BankModels.BankAccount])
}

class GetBankAccountsInteractor: BaseInteractor {

    weak var presenter: GetBankAccountsInteractorCallbackProtocol!
    private let santanderAccountsWorker: GetSantanderAccountsWorkerAlias!
    private let getUserworker: GetUserLocalWorkerAlias!
    private let setUserWorker: SetUserLocalWorkerAlias!

    init(santanderAccountsWorker: GetSantanderAccountsWorkerAlias = GetSantanderAccountsWorker(), getUserWorker: GetUserLocalWorkerAlias = GetUserLocalWorker(), setUserWorker: SetUserLocalWorker = SetUserLocalWorker()) {
        
        self.santanderAccountsWorker = santanderAccountsWorker
        self.getUserworker = getUserWorker
        self.setUserWorker = setUserWorker
        super.init()
    }
}

extension GetBankAccountsInteractor: GetBankAccountsInteractorProtocol {

    func getBankAccounts(bank: BankModels.BankOption, userName: String) {
        
        switch bank.kind {
        case .santander:
            santanderAccountsWorker.execute(input: userName) { [weak self] (result) in
                guard let self = self else { return }
                
                switch result {
                case .success(let accounts):
                    self.presenter.updateBankAccounts(accounts)
                case .failure(let error):
                    print("que pacha aqui")
                }
            }
        default:
            print("que pacha aqui")
        }
    }
}
