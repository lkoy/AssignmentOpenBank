//
//  SetUserLocalWorkerWorker.swift
//  AssignmentOpenBank
//
//  Created by pips on 03/01/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import Foundation

enum SetUserLocalWorkerError: Error {
    case persistingUserError
}

typealias SetUserLocalWorkerAlias = BaseWorker<BankModels.User, Result<BankModels.User, SetUserLocalWorkerError>>

final class SetUserLocalWorker: SetUserLocalWorkerAlias {
    
    private let coreDataManager: CoreDataManageable
    
    init(coreDataManager: CoreDataManageable = CoreDataManager(withContainerName: CoreDataContainerNames.generic)) {
        self.coreDataManager = coreDataManager
    }
    
    override func job(input: BankModels.User, completion: @escaping ((Result<BankModels.User, SetUserLocalWorkerError>) -> Void)) {
        coreDataManager.performBackgroundTask(block: { [weak self] (context) in
            guard let self = self else { return }
            
            do {
                if let contactToUpdate = context.first(entity: MOUser.self, where: NSPredicate(format: "name == %@", input.name ?? "")) {
//                    context.deleteAll(entriesFor: MOTransaction.self)
//                    context.deleteAll(entriesFor: MOBankAccount.self)
                    input.convert(to: contactToUpdate)
                } else {
                    input.convert(in: context)
                }
                
                try context.save()
                
                completion(.success(input))
            } catch {
                completion(.failure(SetUserLocalWorkerError.persistingUserError))
            }
        })
    }
    
}
