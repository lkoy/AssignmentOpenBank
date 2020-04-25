//
//  SantanderTransferBody.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 15/02/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import Foundation

struct SantanderTransferBody: Codable, Equatable {

    let redirectUri: String
    let accountFrom: String?
    let beneficiaryData: BeneficiaryData
    let value: ValueData
    let spendingPolicy: String
    let destinationCountry: String?
    let concept: String?
    let type: String
    let immediately: Bool?

    struct BeneficiaryData: Codable, Equatable {
        let accountTo: String
        let currencyTo: String?
        let accountName: String
        let residenceCountry: String
        
        private enum CodingKeys: String, CodingKey {
            case accountTo = "account_to"
            case currencyTo = "currency_to"
            case accountName = "account_name"
            case residenceCountry = "residence_country"
        }
    }
    
    struct ValueData: Codable, Equatable {
        let amount: String
        let currency: String
    }
    
    private enum CodingKeys: String, CodingKey {
        case redirectUri = "redirect_uri"
        case accountFrom = "account_from"
        case beneficiaryData = "beneficiary_data"
        case value = "value"
        case spendingPolicy = "spending_policy"
        case destinationCountry = "destination_country"
        case concept = "concept"
        case type = "type"
        case immediately = "immediately"
    }
}

//{
//  "redirect_uri": "http://idealista.com",
//  "account_from": "ES8801826154820201528264",
//  "beneficiary_data": {
//    "residence_country": "Laos",
//    "account_name": "5427580273141643",
//    "account_to": "4298310314220852",
//    "currency_to": "KZT"
//  },
//  "value": {
//    "amount": "100.00",
//    "currency": "EUR"
//  },
//  "spending_policy": "SHARED",
//  "destination_country": "ES",
//  "concept": "Purchases on Gateway Payments",
//  "type": "sepa_credit_transfer",
//  "immediately": true,
//}
