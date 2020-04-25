//
//  GetBankServiceTokensInteractorInteractor.swift
//  AssignmentOpenBank
//
//  Created by pips on 15/02/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import Foundation

enum GetBankServiceTokensError: Error {
    case getTokenError
    case storeTokenError
    case codeInvalidError
    case unknownError
}

protocol GetBankServiceTokensInteractorProtocol: BaseInteractorProtocol {
    func getTokenWithComponents(_ components: URLComponents, bank: BankModels.BankOption, userName: String)
}

protocol GetBankServiceTokensInteractorCallbackProtocol: BaseInteractorCallbackProtocol {
    func acceptConsentsSuccess(userName: String)
    func acceptConsentsCancel()
    func acceptConsentsFailure(with error: GetBankServiceTokensError)
}

class GetBankServiceTokensInteractor: BaseInteractor {

    weak var presenter: GetBankServiceTokensInteractorCallbackProtocol!
    private let worker: GetSantanderTokensWorkerAlias
    private let santanderServiceTokenKeychain: CodableKeychain<SantanderModels.Token>

    init(withGetSantanderTokensWorker worker: GetSantanderTokensWorkerAlias = GetSantanderTokensWorker(), santanderTokenKeychain: CodableKeychain<SantanderModels.Token> = SantanderAuthTokenKeychainBuilder.build()) {
        
        self.worker = worker
        self.santanderServiceTokenKeychain = santanderTokenKeychain
        super.init()
    }
}

extension GetBankServiceTokensInteractor: GetBankServiceTokensInteractorProtocol {

    func getTokenWithComponents(_ components: URLComponents, bank: BankModels.BankOption, userName: String) {
        
        if let _ = components.valueOfQueryItem(with: "authorize_error") {
                presenter.acceptConsentsCancel()
        } else {
            guard let code = components.valueOfQueryItem(with: "code") else {
                    presenter.acceptConsentsFailure(with: .codeInvalidError)
                    return
            }
            worker.execute(input: GetSantanderTokensParameter(code: code)) { [weak self] (result) in
                guard let self = self else { return }
                
                switch result {
                case .success(let tokens):
                    do {
                        try self.santanderServiceTokenKeychain.store(codable: tokens, user: userName)
                        self.presenter.acceptConsentsSuccess(userName: userName)
                    } catch {
                        self.presenter.acceptConsentsFailure(with: .storeTokenError)
                    }
                case .failure(let error):
                    switch error {
                    case .getTokenError:
                        self.presenter.acceptConsentsFailure(with: .getTokenError)
                    }
                }
            }
        }
    }
}
