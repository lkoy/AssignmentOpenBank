//
//  BankAccountMapper.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 30/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

import Foundation

final class BankAccountMapper {
    
    // MARK: - Santander mapper
    final func map(santanderData: Api.Santander.AccountData, userName: String) -> [BankModels.BankAccount] {
        guard !santanderData.accountList.isEmpty else {
            return []
        }
        
        var accounts: [BankModels.BankAccount] = []
        santanderData.accountList.forEach { (account) in
            guard let mapped = map(account, user: userName) else {
                return
            }
            accounts.append(mapped)
        }
        return accounts
    }
    
    final func map(_ santanderAccount: Api.Santander.AccountData.Account, user: String) -> BankModels.BankAccount? {
        
        return BankModels.BankAccount(accountUser: user,
                                      bank: BankModels.BankOption(kind: .santander),
                                      bic: provider.configuration.santander.bic,
                                      number: santanderAccount.iban,
                                      accountId: "",
                                      accountType: "IBAN",
                                      balance: 0,
                                      currency: santanderAccount.currency,
                                      primary: false)
    }
    
    final func map(santanderBalance: Api.Santander.AccountBalance, user: String) -> BankModels.BankAccount {
        
        let balances = santanderBalance.account?.balances?[0]
        
        return BankModels.BankAccount(accountUser: user,
                                      bank: BankModels.BankOption(kind: .santander),
                                      bic: provider.configuration.santander.bic,
                                      number: santanderBalance.account?.iban ?? "",
                                      accountId: "",
                                      accountType: balances?.creditDebitIndicator ?? "",
                                      balance: Decimal(string: balances?.balance?.amount?.content ?? "") ?? 0,
                                      currency: balances?.balance?.amount?.currency ?? "",
                                      primary: false)
    }
}
