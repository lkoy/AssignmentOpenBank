//
//  SantanderTransferBodyMapper.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 15/02/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import Foundation

protocol SantanderTransferBodyMapperProtocol {
    func getPaymentInitiationBody(_ parameters: SendMoneySantanderParameters) -> SantanderTransferBody
}

final class SantanderTransferBodyMapper {

    final func getPaymentInitiationBody(_ parameters: SendMoneySantanderParameters) -> SantanderTransferBody {
        
        let beneficiaryData = SantanderTransferBody.BeneficiaryData(accountTo: parameters.accountTo,
                                                                    currencyTo: parameters.currencyTo,
                                                                    accountName: parameters.accountName,
                                                                    residenceCountry: parameters.residenceCountry)
        
        let valueData = SantanderTransferBody.ValueData(amount: parameters.amount.formattedSantanderAmount ?? "", currency: parameters.currency)
        
        let tansferBody = SantanderTransferBody(redirectUri: parameters.redirectUri,
                                                accountFrom: parameters.accountFrom,
                                                beneficiaryData: beneficiaryData,
                                                value: valueData,
                                                spendingPolicy: parameters.spendingPolicy,
                                                destinationCountry: parameters.destinationCountry,
                                                concept: parameters.concept,
                                                type: parameters.type,
                                                immediately: parameters.inmediately)

        return tansferBody
    }
}
