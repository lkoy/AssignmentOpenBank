//
//  GetBankTokensInteractor.swift
//  AssignmentOpenBank
//
//  Created by pips on 29/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

import Foundation

enum GetBankTokensError: Error {
    case getTokenError
    case getUsernameError
    case storeTokenError
    case codeInvalidError
    case getAuthServiceError
    case unknownError
}

protocol GetBankTokensInteractorProtocol: BaseInteractorProtocol {
    func getTokenWithComponents(_ components: URLComponents, bank: BankModels.BankOption)
}

protocol GetBankTokensInteractorCallbackProtocol: BaseInteractorCallbackProtocol {
    func signInSuccess(userName: String)
    func signInFailure(with error: GetBankTokensError)
    func acceptConsentsNeeded(with url: String, userName: String)
}

class GetBankTokensInteractor: BaseInteractor {

    weak var presenter: GetBankTokensInteractorCallbackProtocol!
    private let santanderTokensWorker: GetSantanderTokensWorkerAlias
    private let santanderUserDetailsWorker: GetSantanderUserDetailsWorkerAlias
    private let santanderServiceAuthWorker: GetSantanderServiceAuthorisationWorkerAlias
    private let santanderTokenKeychain: CodableKeychain<SantanderModels.Token>

    init(santanderWorker: GetSantanderTokensWorkerAlias = GetSantanderTokensWorker(), santanderUserDetailsWorker: GetSantanderUserDetailsWorkerAlias = GetSantanderUserDetailsWorker(), santanderServiceAuthWorker: GetSantanderServiceAuthorisationWorkerAlias = GetSantanderServiceAuthorisationWorker(), santanderTokenKeychain: CodableKeychain<SantanderModels.Token> = SantanderPreAuthTokenKeychainBuilder.build()) {
        
        self.santanderTokensWorker = santanderWorker
        self.santanderUserDetailsWorker = santanderUserDetailsWorker
        self.santanderServiceAuthWorker = santanderServiceAuthWorker
        self.santanderTokenKeychain = santanderTokenKeychain
        super.init()
    }
    
    private func getSantanderServiceAuthorisation(username: String, token: String) {
        
        let params = GetSantanderServiceAuthorisationParameters(token: token, recurringIndicator: true, frequency: 5)
        
        self.santanderServiceAuthWorker.execute(input: params) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let url):
                self.presenter.acceptConsentsNeeded(with: url, userName: username)
            case .failure:
                self.presenter.signInFailure(with: .getAuthServiceError)
            }
        }
    }
}

extension GetBankTokensInteractor: GetBankTokensInteractorProtocol {
    
    func getTokenWithComponents(_ components: URLComponents, bank: BankModels.BankOption) {
        
        switch bank.kind {
        case .santander:
            guard let code = components.valueOfQueryItem(with: "code") else {
                    presenter.signInFailure(with: .codeInvalidError)
                    return
            }
            santanderTokensWorker.execute(input: GetSantanderTokensParameter(code: code)) { [weak self] (result) in
                guard let self = self else { return }
                
                switch result {
                case .success(let tokens):
                    self.santanderUserDetailsWorker.execute(input: tokens.accessToken) { [weak self] (result) in
                        guard let self = self else { return }
                        
                        switch result {
                        case .success(let userName):
                            do {
                                try self.santanderTokenKeychain.store(codable: tokens, user: userName)
                                self.getSantanderServiceAuthorisation(username: userName, token: tokens.accessToken)
                            } catch {
                                self.presenter.signInFailure(with: .storeTokenError)
                            }
                        case .failure:
                            self.presenter.signInFailure(with: .getUsernameError)
                        }
                    }
                case .failure(let error):
                    switch error {
                    case .getTokenError:
                        self.presenter.signInFailure(with: .getTokenError)
                    }
                }
            }
        default:
            self.presenter.signInFailure(with: .unknownError)
        }
    }
}
