//
//  SelectBankWorker.swift
//  AssignmentOpenBank
//
//  Created by pips on 29/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

import Foundation

enum GetBankOptionsWorkerError: Error {
    case getBanksError
}

typealias GetBankOptionsWorkerAlias = BaseWorker<Configuration, Result<BankModels.BankOption, GetBankOptionsWorkerError>>

final class GetBankOptionsWorker: GetBankOptionsWorkerAlias {

    private let mapper: BankOptionMapper
    
    init(mapper: BankOptionMapper = BankOptionMapper()) {
        
        self.mapper = mapper
        super.init()
    }
    
    override func job(input: Configuration, completion: @escaping ((Result<BankModels.BankOption, GetBankOptionsWorkerError>) -> Void)) {
        
        completion(.success(mapper.map(bankOption: input.general.bankEntity)))
    }

}
