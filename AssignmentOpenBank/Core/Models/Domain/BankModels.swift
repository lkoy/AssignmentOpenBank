//
//  MoneyouModels.swift
//  AssignmentMoneyou
//
//  Created by Iglesias, Gustavo on 22/09/2019.
//  Copyright © 2019 ttg. All rights reserved.
//

import Foundation
import UIKit.UIColor

enum BankModels {

    struct BankOption: Codable, Equatable {
        let kind: Kind
        
        enum Kind: String, Equatable, Codable, CaseIterable {
            case santander
            case none
        }
    }
    
    struct BankAccount: Codable, Equatable, DataConvertible {
        typealias ManagedObject = MOBankAccount
        
        let accountUser: String?
        let bank: BankOption
        let bic: String
        let number: String?
        let accountId: String?
        var accountType: String?
        var balance: Decimal
        var currency: String?
        let primary: Bool
        
        @discardableResult
        func convert(to base: MOBankAccount) -> MOBankAccount? {
            let managedObject = base
                    
            managedObject.accountUser = self.accountUser
            managedObject.accountId = self.accountId
            managedObject.accountType = self.accountType
            managedObject.balance = self.balance as NSDecimalNumber
            managedObject.bank = self.bank.kind.bankName
            managedObject.bic = self.bic
            managedObject.currency = self.currency
            managedObject.number = self.number
            managedObject.primary = self.primary
            
            return managedObject
        }
        
        static func convert(from managedObject: MOBankAccount) -> BankModels.BankAccount? {
            
            let bankKind = BankOption.Kind.bankKind(stringKind: managedObject.bank)
            
            return BankAccount(accountUser: managedObject.accountUser,
                               bank: bankKind,
                               bic: managedObject.bic ?? "",
                               number: managedObject.number,
                               accountId: managedObject.accountId,
                               accountType: managedObject.accountType,
                               balance: managedObject.balance! as Decimal,
                               currency: managedObject.currency,
                               primary: managedObject.primary)
        }
    }
    
    struct User: Codable, Equatable, DataConvertible {
        typealias ManagedObject = MOUser
        
        let name: String?
        var transactions: [Transaction]
        var bankAccounts: [BankAccount]
        
        @discardableResult
        func convert(to base: MOUser) -> MOUser? {
            let managedObject = base
                    
            managedObject.name = self.name
            managedObject.transactions = NSSet(array: transactions.compactMap({ $0.convert(in: managedObject.managedObjectContext!) }))
            managedObject.bankAccounts = NSSet(array: bankAccounts.compactMap({ $0.convert(in: managedObject.managedObjectContext!) }))
            
            return managedObject
        }
        
        static func convert(from managedObject: MOUser) -> BankModels.User? {
            
            var transactionItems: [Transaction] {
                guard let moTransactionItem = managedObject.transactions?.allObjects as? [MOTransaction] else {
                    return []
                }
                return moTransactionItem.compactMap({ return Transaction.convert(from: $0) })
            }
            
            var bankAccountItems: [BankAccount] {
                guard let moTransactionBalance = managedObject.bankAccounts?.allObjects as? [MOBankAccount] else {
                    return []
                }
                return moTransactionBalance.compactMap({ return BankAccount.convert(from: $0) })
            }
            
            return User(name: managedObject.name,
                        transactions: transactionItems,
                        bankAccounts: bankAccountItems)
            
        }
    }
    
    struct Transaction: Codable, Equatable, DataConvertible {
        typealias ManagedObject = MOTransaction
        
        let amount: Decimal
        let bankTransactionId: String?
        let concept: String?
        let currency: String?
        let destinationBank: String?
        let destinationBankNumber: String?
        let destinationUserPhone: String?
        let destinationUserUuid: String?
        let originBank: String?
        let originBankNumber: String?
        let originUserPhone: String?
        let originUserUuid: String?
        let status: String?
        let timestamp: Date?
        let transferType: String?
        
        @discardableResult
        func convert(to base: MOTransaction) -> MOTransaction? {
            let managedObject = base
                    
            managedObject.amount = self.amount as NSDecimalNumber
            managedObject.bankTransactionId = self.bankTransactionId
            managedObject.concept = self.concept
            managedObject.currency = self.currency
            managedObject.destinationBank = self.destinationBank
            managedObject.destinationBankNumber = self.destinationBankNumber
            managedObject.destinationUserPhone = self.destinationUserPhone
            managedObject.destinationUserUuid = self.destinationUserUuid
            managedObject.originBank = self.originBank
            managedObject.originBankNumber = self.originBankNumber
            managedObject.originUserPhone = self.originUserPhone
            managedObject.originUserUuid = self.originUserUuid
            managedObject.status = self.status
            managedObject.timestamp = self.timestamp
            managedObject.transferType = self.transferType
            
            return managedObject
        }
        
        static func convert(from managedObject: MOTransaction) -> BankModels.Transaction? {
            
            return Transaction(amount: managedObject.amount! as Decimal,
                               bankTransactionId: managedObject.bankTransactionId,
                               concept: managedObject.concept,
                               currency: managedObject.currency,
                               destinationBank: managedObject.destinationBank,
                               destinationBankNumber: managedObject.destinationBank,
                               destinationUserPhone: managedObject.destinationUserPhone,
                               destinationUserUuid: managedObject.destinationUserUuid,
                               originBank: managedObject.originBank,
                               originBankNumber: managedObject.originBankNumber,
                               originUserPhone: managedObject.originUserPhone,
                               originUserUuid: managedObject.originUserUuid,
                               status: managedObject.status,
                               timestamp: managedObject.timestamp,
                               transferType: managedObject.transferType)
        }
    }
}

extension BankModels.BankOption.Kind {
    
    var image: String {
        switch self {
        case .santander:
            return "santander_logo_big"
        case .none:
        return ""
       }
    }
    
    var icon: String {
        switch self {
        case .santander:
            return "santander_logo_small"
        case .none:
            return ""
        }
    }
    
    var bankName: String {
        switch self {
        case .santander:
            return "santander"
        case .none:
            return ""
        }
    }
    
    var primaryColor: UIColor {
        switch self {
        case .santander:
            return .appRed
        case .none:
            return .appWhite
        }
    }
    
    static func bankKind(stringKind: String?) -> BankModels.BankOption {
        guard let kindString = stringKind else {
            return BankModels.BankOption(kind: .none)
        }
        
        return BankModels.BankOption(kind: .santander)
    }
}
