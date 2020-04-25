//
//  GetAccountInteractor.swift
//  AssignmentMoneyou
//
//  Created by ttg on 23/09/2019.
//  Copyright © 2019 ttg. All rights reserved.
//

import Foundation

enum SplashInteractorError {
    case noData
    case showError
}

protocol SplashInteractorProtocol: BaseInteractorProtocol {
    func getState()
}

protocol SplashInteractorCallbackProtocol: BaseInteractorCallbackProtocol {

    func userRegistered()
    func bankOption(value: BankModels.BankOption)
    func firstTimeUser()
    func showError(type: SplashInteractorError)
}

class SplashInteractor: BaseInteractor {

    weak var presenter: SplashInteractorCallbackProtocol!
    private let datastore: PreferencesDataStore
    private let bankOptionsworker: GetBankOptionsWorkerAlias
    private let checkBankAccountStatus: GetBankAccountStateWorkerAlias

    init(withBankOptionsWorker worker: GetBankOptionsWorkerAlias = GetBankOptionsWorker(), datastore: PreferencesDataStore = PreferencesDataStore(), checkBankAccountStatus: GetBankAccountStateWorkerAlias = GetBankAccountStateWorker()) {
        
        self.bankOptionsworker = worker
        self.datastore = datastore
        self.checkBankAccountStatus = checkBankAccountStatus
        super.init()
    }
    
    func getBankOptionsAvailable(config: Configuration) {
        self.bankOptionsworker.execute(input: config) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let option):
                self.presenter.bankOption(value: option)
            case .failure:
                self.presenter.showError(type: SplashInteractorError.noData)
            }
        }
    }
}

extension SplashInteractor: SplashInteractorProtocol {
    
    func getState() {
        
        if !datastore.getAppFirstTimeLaunched() {
            
            self.presenter.firstTimeUser()
        } else {
            self.checkBankAccountStatus.execute { [weak self] (result) in
                guard let self = self else { return }
                
                switch result {
                case .success(let state):
                    switch state {
                    case .bankAccountNotRegistered:
                        self.getBankOptionsAvailable(config: provider.configuration)
                    case .bankAccountRegistered:
                        self.presenter.userRegistered()
                    }
                case .failure:
                    self.presenter.showError(type:  SplashInteractorError.showError)
                }
            }
        }
    }
}
