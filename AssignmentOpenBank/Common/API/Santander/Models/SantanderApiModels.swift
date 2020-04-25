//
//  SantanderApiModels.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 28/01/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import Foundation

enum Api {
    
    enum Santander {
        
        struct Token: Codable, Equatable {
            let accessToken: String
            let tokenType: String?
            let expiresIn: Int?
            let refreshToken: String
            var scope: String?
            
            private enum CodingKeys: String, CodingKey {
                case accessToken = "access_token"
                case tokenType = "token_type"
                case expiresIn = "expires_in"
                case refreshToken = "refresh_token"
                case scope = "scope"
            }
        }
        
        struct UserDetails: Codable, Equatable {
            let clientId: String
            let userId: String?
            let expirationDate: String?
            var scope: String?
            
            private enum CodingKeys: String, CodingKey {
                case clientId = "client_id"
                case userId = "user_id"
                case expirationDate = "expiration_date"
                case scope = "scope"
            }
        }
        
        struct AccountData: Codable, Equatable {
            let accountList: [Account]

            struct Account: Codable, Equatable {
                let currency: String?
                let name: String?
                let iban: String?
            }
        }
        
        struct AccountBalance: Codable, Equatable {
            let account: Account?
            let requestId: String?

            struct Account: Codable, Equatable {
                let iban: String?
                let balances: [Balances]?
                
                struct Balances: Codable, Equatable {
                    let balance: Balance?
                    let consBalance: ConsBalance?
                    let pConsolidation: PBalance?
                    let deduction: Deduction?
                    let creditDebitIndicator: String?
                    let timestamp: String?
                    
                    struct Balance: Codable, Equatable {
                        let amount: Amount?
                    }
                    
                    struct ConsBalance: Codable, Equatable {
                        let amount: Amount?
                    }
                    
                    struct PBalance: Codable, Equatable {
                        let amount: Amount?
                    }
                    
                    struct Deduction: Codable, Equatable {
                        let amount: Amount?
                    }
                    
                    struct Amount: Codable, Equatable {
                        let content: String?
                        let currency: String?
                    }
                    
                    private enum CodingKeys: String, CodingKey {
                        case balance = "balance"
                        case consBalance = "cons_balance"
                        case pConsolidation = "p_consolidation"
                        case deduction = "deduction"
                        case creditDebitIndicator = "creditDebitIndicator"
                        case timestamp = "timestamp"
                    }
                }
            }
        }
        
        struct Transfer: Codable, Equatable {
            let paymentData: PaymentData?
            let status: String?
            let requestId: String?
            
            struct PaymentData: Codable, Equatable {
                let fee: Fee?
                let value: Value?
                let type: String?
                let paymentId: String?
                
                struct Fee: Codable, Equatable {
                    let spendingPolicy: String?
                    let currency: String?
                    let amount: String?
                    
                    private enum CodingKeys: String, CodingKey {
                        case spendingPolicy = "spending_policy"
                        case currency = "currency"
                        case amount = "amount"
                    }
                }
                
                struct Value: Codable, Equatable {
                    let currency: String?
                    let amount: String?
                    
                    private enum CodingKeys: String, CodingKey {
                        case currency = "currency"
                        case amount = "amount"
                    }
                }
                
                private enum CodingKeys: String, CodingKey {
                    case fee = "currency"
                    case value = "value"
                    case type = "type"
                    case paymentId = "payment_id"
                }
            }
            
            private enum CodingKeys: String, CodingKey {
                case paymentData = "payment_data"
                case status = "status"
                case requestId = "Request-ID"
            }
        }
    }
}
