//
//  GetHomeInformationInteractor.swift
//  AssignmentOpenBank
//
//  Created by pips on 04/01/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import Foundation

enum GetHomeInformationInteractorError {
    case getLocalUserError
}

protocol GetHomeInformationInteractorProtocol: BaseInteractorProtocol {

    func getUserInfo()
}

protocol GetHomeInformationInteractorCallbackProtocol: BaseInteractorCallbackProtocol {

    func updateUser(user: BankModels.User)
    func showError(type: GetHomeInformationInteractorError)
}

class GetHomeInformationInteractor: BaseInteractor {

    weak var presenter: GetHomeInformationInteractorCallbackProtocol!
    private let getUserworker: GetUserLocalWorkerAlias!
    private let setUserLocalWorker: SetUserLocalWorkerAlias!
    private let datastore: PreferencesDataStore

    init(withGetHomeInformationWorker userInfoWorker: GetUserLocalWorkerAlias = GetUserLocalWorker(), setUserLocalWorker: SetUserLocalWorkerAlias = SetUserLocalWorker(), datastore: PreferencesDataStore = PreferencesDataStore()) {
        
        self.getUserworker = userInfoWorker
        self.setUserLocalWorker = setUserLocalWorker
        self.datastore = datastore
        super.init()
    }
}

extension GetHomeInformationInteractor: GetHomeInformationInteractorProtocol {

    func getUserInfo() {
        
        self.getUserworker.execute() { [weak self] (result) in
            guard let self = self else { return }

            switch result {
            case .success(let userRegistered):
                self.presenter.updateUser(user: userRegistered)
            case .failure:
                self.presenter.showError(type: GetHomeInformationInteractorError.getLocalUserError)
            }
        }
    }
}
