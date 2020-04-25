//
//  Decimal+StringWorker.swift
//  AssignmentOpenBank
//
//  Created by pips on 07/01/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import Foundation

extension Decimal {
    var formattedAmount: String? {
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: self as NSDecimalNumber)
    }
    
    var formattedSantanderAmount: String? {
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = "."
        formatter.groupingSeparator = ","
        return formatter.string(from: self as NSDecimalNumber)
    }
}
