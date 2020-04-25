//
//  TransferDetailsRouter.swift
//  AssignmentOpenBank
//
//  Created by pips on 05/04/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import Foundation

protocol TransferDetailsRouterProtocol: BaseRouterProtocol {

    func navigateBack()
}

class TransferDetailsRouter: BaseRouter, TransferDetailsRouterProtocol {

    func navigateBack() {
        
        viewController.navigationController?.popViewController(animated: true)
    }
}
