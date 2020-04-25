//
//  HomeModels.swift
//  AssignmentOpenBank
//
//  Created by pips on 19/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

import Foundation
import UIKit.UIColor

enum Home {

    struct ViewModel: Equatable {
        
        let imageUrl: String
        let accounts: [Account]
        let transactions: [Transaction]
        
        struct Account: Equatable {
            let accountName: String
            let balance: String
            let primary: Bool
            let primaryColor: UIColor
        }
        
        struct Transaction: Equatable {
            let date: String
            let username: String
            let amount: String
        }
    }

}
