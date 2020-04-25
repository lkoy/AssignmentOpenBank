//
//  AccountSelectionModels.swift
//  AssignmentOpenBank
//
//  Created by pips on 29/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

import Foundation
import UIKit.UIImage

enum AccountSelection {

    struct ViewModel: Equatable {
        
        let isLoading: Bool
        let accounts: [Account]
        
        struct Account: Equatable {
            let iban: String
            let balance: String
            let image: UIImage?
        }
    }

}
