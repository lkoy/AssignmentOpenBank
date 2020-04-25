//
//  BankAuthInteractor.swift
//  AssignmentOpenBank
//
//  Created by pips on 14/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

import Foundation

protocol BankAuthInteractorProtocol: BaseInteractorProtocol {

    func getAuthUrl(for: BankModels.BankOption)
}

protocol BankAuthInteractorCallbackProtocol: BaseInteractorCallbackProtocol {

    func bankAuthUrl(_ url: URL)
}

class BankAuthInteractor: BaseInteractor {

    weak var presenter: BankAuthInteractorCallbackProtocol!
    private let worker: BankAuthWorkerAlias

    init(withBankAuthWorker worker: BankAuthWorkerAlias = BankAuthWorker()) {
        self.worker = worker
        super.init()
    }
    
    private func getSantanderUrl() -> String {
        return "\(provider.configuration.santander.authUrl)?client_id=\(provider.configuration.santander.clientId)&redirect_uri=\(provider.configuration.santander.redirectUri)&response_type=code"
    }
}

extension BankAuthInteractor: BankAuthInteractorProtocol {
    
    func getAuthUrl(for bank: BankModels.BankOption) {
        
        let stringUrl: String
        switch bank.kind {
        case .santander:
            stringUrl = getSantanderUrl()
        default:
            stringUrl = "https://www.google.es"
        }
        
        guard let url = URL(string: stringUrl) else {
            return
        }
        self.presenter.bankAuthUrl(url)
    }
}
