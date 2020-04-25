//
//  UpdateBankAccountLocalWorkerWorker.swift
//  AssignmentOpenBank
//
//  Created by pips on 13/01/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import Foundation

enum UpdateBankAccountLocalWorkerError: Error {
    case persistingBankAccountError
}

typealias UpdateBankAccountLocalWorkerAlias = BaseWorker<BankModels.BankAccount, Result<BankModels.BankAccount, UpdateBankAccountLocalWorkerError>>

final class UpdateBankAccountLocalWorker: UpdateBankAccountLocalWorkerAlias {
    
    private let coreDataManager: CoreDataManageable
    
    init(coreDataManager: CoreDataManageable = CoreDataManager(withContainerName: CoreDataContainerNames.generic)) {
        self.coreDataManager = coreDataManager
    }
    
    override func job(input: BankModels.BankAccount, completion: @escaping ((Result<BankModels.BankAccount, UpdateBankAccountLocalWorkerError>) -> Void)) {
        
        coreDataManager.performBackgroundTask { [weak self] (context) in
            guard let self = self else { return }
            
            do {
                if let contactToUpdate = context.first(entity: MOBankAccount.self, where: NSPredicate(format: "number == %@", String(input.number ?? ""))) {
                    input.convert(to: contactToUpdate)
                } else {
                    input.convert(in: context)
                }
                try context.save()
                completion(.success(input))
            } catch {
                completion(.failure(.persistingBankAccountError))
            }
        }
    }
    
}
