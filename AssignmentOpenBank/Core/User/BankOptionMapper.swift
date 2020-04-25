//
//  BankOptionMapper.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 29/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

import Foundation

class BankOptionMapper {
    
    final func map(bankOption: Configuration.General.BankEntity) -> BankModels.BankOption {
        
        let optionKind: BankModels.BankOption.Kind
        switch bankOption {
        case .santander:
            optionKind = .santander
        }

        return BankModels.BankOption(kind: optionKind)
    }
}
