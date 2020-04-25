//
//  SantanderExecutionBodyMapper.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 16/02/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import Foundation

protocol SantanderExecutionBodyMapperProtocol {
    func getPaymentExecutionBody(_ parameters: PaymentExecutionSantanderParameters) -> SantanderExecutionBody
}

final class SantanderExecutionBodyMapper {

    final func getPaymentExecutionBody(_ parameters: PaymentExecutionSantanderParameters) -> SantanderExecutionBody {

        return SantanderExecutionBody(signatureToken: parameters.signatureToken)
    }
}
