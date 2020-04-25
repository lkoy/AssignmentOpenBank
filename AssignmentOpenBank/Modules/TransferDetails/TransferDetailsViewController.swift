//
//  TransferDetailsViewController.swift
//  AssignmentOpenBank
//
//  Created by pips on 05/04/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import UIKit

final class TransferDetailsViewController: BaseViewController {

    override var prefersNavigationBarHidden: Bool { return true }
    
    var presenter: TransferDetailsPresenterProtocol!

    // MARK: - Component Declaration

    private enum ViewTraits {
        static let marginsTopBar = UIEdgeInsets(top: 10, left: 15, bottom: 0, right: 0)
        static let margins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    private var topBar: TopBarView!
    
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

    // MARK: - Setup

    override func setupComponents() {

        view.backgroundColor = .white
        
        topBar = TopBarView(type: .back)
        topBar.translatesAutoresizingMaskIntoConstraints = false
        topBar.delegate = self
        view.addSubview(topBar)
    }

    override func setupConstraints() {

        NSLayoutConstraint.activate([
            topBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: ViewTraits.marginsTopBar.top),
            topBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    override func setupAccessibilityIdentifiers() {
        
    }

    // MARK: - Actions

    // MARK: Private Methods

}

// MARK: - TransferDetailsViewControllerProtocol
extension TransferDetailsViewController: TransferDetailsViewControllerProtocol {
 
}

// MARK: - TopBar Delegate
extension TransferDetailsViewController: TopBarViewDelegate {
    
    func topBarView(_ topBarView: TopBarView, didPressItem item: Button) {
        
        self.presenter.close()
    }
}
