//
//  TransactionMapper.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 07/01/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import Foundation

class TransactionMapper {
    
    final func map(apiTransaction: Api.Santander.Transfer) -> BankModels.Transaction {
        
        return BankModels.Transaction(amount: Decimal(string: apiTransaction.paymentData?.value?.amount ?? "0") ?? 0,
                                      bankTransactionId: apiTransaction.paymentData?.paymentId,
                                      concept: "Concepto",
                                      currency: apiTransaction.paymentData?.value?.currency ?? "EUR",
                                      destinationBank: "Destination bank",
                                      destinationBankNumber: "DestinationBankNumber",
                                      destinationUserPhone: "DestinationUserPhone",
                                      destinationUserUuid: "DestinationUserUuid",
                                      originBank: "santander",
                                      originBankNumber: "OriginBankNumber",
                                      originUserPhone: "OriginBankPhone",
                                      originUserUuid: "OriginBankUuid",
                                      status: "",
                                      timestamp: Date(),
                                      transferType: apiTransaction.paymentData?.type ?? "")
    }
}
