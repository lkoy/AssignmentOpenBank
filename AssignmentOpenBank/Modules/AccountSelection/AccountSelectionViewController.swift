//
//  AccountSelectionViewController.swift
//  AssignmentOpenBank
//
//  Created by pips on 29/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

import UIKit

final class AccountSelectionViewController: BaseViewController {
    
    override var prefersNavigationBarHidden: Bool { return true }

    var presenter: AccountSelectionPresenterProtocol!

    // MARK: - Component Declaration

    private enum ViewTraits {
        static let marginsTopBar = UIEdgeInsets(top: 10, left: 15, bottom: 0, right: 0)
        static let margins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    }
    
    private var topBar: TopBarView!
    private var accountsTableView: UITableView!
    
    private var viewModel = AccountSelection.ViewModel(isLoading: true, accounts: [])
    
    public enum AccessibilityIds {
        
    }

    // MARK: - ViewLife Cycle
    /*
     Order:
     - viewDidLoad
     - viewWillAppear
     - viewDidAppear
     - viewWillDisapear
     - viewDidDisappear
     - viewWillLayoutSubviews
     - viewDidLayoutSubviews
     */

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.presenter.prepareView()
    }
    
    // MARK: - Setup

    override func setupComponents() {

        view.backgroundColor = .white
        
        topBar = TopBarView(type: .back, title: "Selecciona tu cuenta", subtitle: "Esta cuenta sera tu cuenta principal para hacer pagos")
        topBar.translatesAutoresizingMaskIntoConstraints = false
        topBar.delegate = self
        view.addSubview(topBar)
        
        accountsTableView = UITableView(frame: CGRect.zero, style: .plain)
        accountsTableView.translatesAutoresizingMaskIntoConstraints = false
        accountsTableView.register(AccountsTableViewCell.self, forCellReuseIdentifier: AccountsTableViewCell.cellIdentifier)
        accountsTableView.register(SchimmerTableViewCell.self, forCellReuseIdentifier: SchimmerTableViewCell.cellIdentifier)
        accountsTableView.estimatedRowHeight = 70
        accountsTableView.rowHeight = UITableView.automaticDimension
        accountsTableView.separatorStyle = .none
        accountsTableView.dataSource = self
        accountsTableView.delegate = self
        view.addSubview(accountsTableView)
    }

    override func setupConstraints() {

        NSLayoutConstraint.activate([
            topBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: ViewTraits.marginsTopBar.top),
            topBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            accountsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            accountsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            accountsTableView.topAnchor.constraint(equalTo: topBar.bottomAnchor, constant: ViewTraits.margins.bottom),
            accountsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    override func setupAccessibilityIdentifiers() {
        
    }

    // MARK: - Actions

    // MARK: Private Methods

}

// MARK: - AccountSelectionViewControllerProtocol
extension AccountSelectionViewController: AccountSelectionViewControllerProtocol {
 
    func show(_ viewModel: AccountSelection.ViewModel) {
        self.viewModel = viewModel
        self.accountsTableView.reloadData()
    }
}

// MARK: - TableView Delegate and Data Source
extension AccountSelectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.viewModel.isLoading {
            return 1
        } else {
            return self.viewModel.accounts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.viewModel.isLoading {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SchimmerTableViewCell.cellIdentifier, for: indexPath) as? SchimmerTableViewCell else {
                fatalError("Remember to register cellIdentifier")
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AccountsTableViewCell.cellIdentifier, for: indexPath) as? AccountsTableViewCell else {
                fatalError("Remember to register cellIdentifier")
            }
            let account = viewModel.accounts[indexPath.row]
            cell.leftImage = account.image
            cell.title = account.iban
            cell.subtitle = account.balance
            return cell
        }
    }
}

extension AccountSelectionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if !self.viewModel.isLoading {
            self.presenter.selectAccount(at: indexPath.row)
        }
    }
}

// MARK: - TopBar Delegate
extension AccountSelectionViewController: TopBarViewDelegate {
    
    func topBarView(_ topBarView: TopBarView, didPressItem item: Button) {
        
        self.presenter.closeAccountSelection()
    }
}
