//
//  TransferDetailsPresenter.swift
//  AssignmentOpenBank
//
//  Created by pips on 05/04/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import Foundation

protocol TransferDetailsViewControllerProtocol: BaseViewControllerProtocol {

}

protocol TransferDetailsPresenterProtocol: BasePresenterProtocol {

    func close()
}

final class TransferDetailsPresenter<T: TransferDetailsViewControllerProtocol, U: TransferDetailsRouterProtocol>: BasePresenter<T, U> {

    private var activeUser: BankModels.User?
    private var transaction: BankModels.Transaction!
    
    init(viewController: T, router: U, transfer: BankModels.Transaction) {
        
        self.transaction = transfer
        super.init(viewController: viewController, router: router)
    }
    
}

extension TransferDetailsPresenter: TransferDetailsPresenterProtocol {

    func close() {
        
        router.navigateBack()
    }
}
