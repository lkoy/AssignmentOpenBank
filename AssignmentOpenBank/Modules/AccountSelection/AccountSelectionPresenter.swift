//
//  AccountSelectionPresenter.swift
//  AssignmentOpenBank
//
//  Created by pips on 29/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

import Foundation

protocol AccountSelectionViewControllerProtocol: BaseViewControllerProtocol {

    func show(_ viewModel: AccountSelection.ViewModel)
}

protocol AccountSelectionPresenterProtocol: BasePresenterProtocol {

    func prepareView()
    func selectAccount(at: Int)
    func closeAccountSelection()
}

final class AccountSelectionPresenter<T: AccountSelectionViewControllerProtocol, U: AccountSelectionRouterProtocol>: BasePresenter<T, U> {

    private let getBankAccountInteractor: GetBankAccountsInteractorProtocol
    private let accountnMapper: AccountSelectionMapper
    private let setPrimaryBankAccountInteractor: SetPrimaryBankAccountInteractorProtocol
    private let bankOption: BankModels.BankOption
    private let userName: String
    
    private var bankAccounts: [BankModels.BankAccount] = []
    
    init(viewController: T, router: U, bankOption: BankModels.BankOption, userName: String, getBankAccountInteractor: GetBankAccountsInteractorProtocol, acountSelectionMapper: AccountSelectionMapper, setPrimaryBankAccountInteractor: SetPrimaryBankAccountInteractorProtocol) {
        
        self.getBankAccountInteractor = getBankAccountInteractor
        self.accountnMapper = acountSelectionMapper
        self.setPrimaryBankAccountInteractor = setPrimaryBankAccountInteractor
        self.bankOption = bankOption
        self.userName = userName
        
        super.init(viewController: viewController, router: router)
    }
    
}

extension AccountSelectionPresenter: AccountSelectionPresenterProtocol {

    func prepareView() {
        self.getBankAccountInteractor.getBankAccounts(bank: self.bankOption, userName: self.userName)
    }
    
    func selectAccount(at: Int) {
        
        self.setPrimaryBankAccountInteractor.storeBankAccount(bankAccounts[at])
    }
    
    func closeAccountSelection() {
        router.navigateBack()
    }
}

extension AccountSelectionPresenter: GetBankAccountsInteractorCallbackProtocol {
    
    func updateBankAccounts(_ bankAccounts: [BankModels.BankAccount]) {
        self.bankAccounts = bankAccounts
        self.viewController.show(accountnMapper.map(accounts: bankAccounts))
    }
}

extension AccountSelectionPresenter: SetPrimaryBankAccountInteractorCallbackProtocol {
    
    func primaryAccountStored() {
        router.navigateToRegistrationComplete()
    }
    
    func showError(type: SetPrimaryBankAccountInteractorError) {
        print("error storing primary bank account")
    }
}
