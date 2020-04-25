//
//  UserInteractor.swift
//  AssignmentOpenBank
//
//  Created by pips on 25/04/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import Foundation

enum UserInteractorError {
    case bankOptionsEmpty
    case localStoreError
}

protocol UserInteractorProtocol: BaseInteractorProtocol {

    func registerUser(name: String)
}

protocol UserInteractorCallbackProtocol: BaseInteractorCallbackProtocol {

    func bankOption(value: BankModels.BankOption)
    func showError(type: UserInteractorError)
}

class UserInteractor: BaseInteractor {

    weak var presenter: UserInteractorCallbackProtocol!
    private let storeUserWorker: SetUserLocalWorkerAlias!
    private let worker: GetBankOptionsWorkerAlias
    private let datastore: PreferencesDataStore

    init(withBankOptionsWorker worker: GetBankOptionsWorkerAlias = GetBankOptionsWorker(), datastore: PreferencesDataStore = PreferencesDataStore(), storeUserWorker: SetUserLocalWorker = SetUserLocalWorker()) {
        
        self.worker = worker
        self.datastore = datastore
        self.storeUserWorker = storeUserWorker
        super.init()
    }
    
    func getBankOptionsAvailable(config: Configuration) {
        self.worker.execute(input: config) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let option):
                self.presenter.bankOption(value: option)
            case .failure:
                self.presenter.showError(type: UserInteractorError.bankOptionsEmpty)
            }
        }
    }
}

extension UserInteractor: UserInteractorProtocol {
    
    func registerUser(name: String) {
        
        let userModel = BankModels.User(name: name,
        transactions: [],
        bankAccounts: [])
        
        self.storeUserWorker.execute(input: userModel) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success( _):
                self.datastore.saveAppFirstTimeLaunched(true)
                self.getBankOptionsAvailable(config: provider.configuration)
            case .failure:
                self.presenter.showError(type: UserInteractorError.localStoreError)
            }
        }
    }

}
