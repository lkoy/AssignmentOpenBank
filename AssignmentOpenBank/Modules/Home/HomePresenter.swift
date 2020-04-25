//
//  HomePresenter.swift
//  AssignmentOpenBank
//
//  Created by pips on 19/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

import Foundation

protocol HomeViewControllerProtocol: BaseViewControllerProtocol {

    func updateView(viewModel: Home.ViewModel)
}

protocol HomePresenterProtocol: BasePresenterProtocol {

    func prepareView()
    func sendMoney()
    func transferSelected(atIndex: Int)
}

final class HomePresenter<T: HomeViewControllerProtocol, U: HomeRouterProtocol>: BasePresenter<T, U> {

    private let getHomeInformationInteractor: GetHomeInformationInteractorProtocol
    private let homeMapper: HomeMapper
    
    private var activeUser: BankModels.User?
    
    init(viewController: T, router: U, getHomeInformationInteractor: GetHomeInformationInteractorProtocol, homeMapper: HomeMapper) {
        
        self.getHomeInformationInteractor = getHomeInformationInteractor
        self.homeMapper = homeMapper
        super.init(viewController: viewController, router: router)
    }
    
}

extension HomePresenter: HomePresenterProtocol {

    func prepareView() {
        self.getHomeInformationInteractor.getUserInfo()
    }
    
    func sendMoney() {
        
        if let user = self.activeUser {
            router.navigateToStartTransaction(with: user.bankAccounts[0])
        }
    }
    
    func transferSelected(atIndex: Int) {
        
        if let user = self.activeUser {
            router.navigateToTranferDetails(with: user.transactions[atIndex])
        }
    }
}

extension HomePresenter: GetHomeInformationInteractorCallbackProtocol {

    func updateUser(user: BankModels.User) {
        
        self.activeUser = user
        self.viewController.updateView(viewModel:homeMapper.map(user: user))
    }
    
    func showError(type: GetHomeInformationInteractorError) {
        print("error")
    }
}
