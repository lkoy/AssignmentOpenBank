//
//  AccountSelectionMapper.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 30/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

import Foundation
import UIKit.UIImage

final class AccountSelectionMapper {

    final func map(accounts: [BankModels.BankAccount]) -> AccountSelection.ViewModel {
        
        var accountsView: [AccountSelection.ViewModel.Account] = []
        for account in accounts {
            
            let image = UIImage(named: account.bank.kind.icon)
            let accountView = AccountSelection.ViewModel.Account(iban: account.number ?? "", balance: account.balance.formattedAmount ?? "", image: image)
            accountsView.append(accountView)
        }
        return AccountSelection.ViewModel(isLoading: false, accounts: accountsView)
    }
}
