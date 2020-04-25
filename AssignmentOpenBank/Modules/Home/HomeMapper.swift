//
//  HomeMapper.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 05/01/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import Foundation

final class HomeMapper {
    
    final func map(user: BankModels.User) -> Home.ViewModel {
        
        var accountsView: [Home.ViewModel.Account] = []
        for account in user.bankAccounts {
            
            let accountView = Home.ViewModel.Account(accountName: account.bank.kind.bankName, balance: "\(account.balance) €", primary: account.primary, primaryColor: account.bank.kind.primaryColor)
            accountsView.append(accountView)
        }
        
        var transactions: [Home.ViewModel.Transaction] = []
        let userTransactions = user.transactions.sorted { $0.timestamp! > $1.timestamp! }
        for transaction in userTransactions {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMMM yyyy"
            if let date = transaction.timestamp, let username = transaction.concept {
                let transactionView = Home.ViewModel.Transaction(date: dateFormatter.string(from: date),
                                                                 username: username,
                                                                 amount: transaction.amount.formattedAmount ?? "")
                transactions.append(transactionView)
            }
        }
        
        return Home.ViewModel(imageUrl: "", accounts: accountsView, transactions: transactions)
    }
}
