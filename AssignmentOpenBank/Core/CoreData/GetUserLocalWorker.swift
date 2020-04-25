//
//  GetUserLocalWorkerWorker.swift
//  AssignmentOpenBank
//
//  Created by pips on 03/01/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import Foundation
import CoreData

enum GetUserLocalWorkerError: Error {
    case retrievingUserError
}

typealias GetUserLocalWorkerAlias = BaseWorker<Void, Result<BankModels.User, GetUserLocalWorkerError>>
final class GetUserLocalWorker: GetUserLocalWorkerAlias {
    
    private let coreDataManager: CoreDataManageable
    
    init(coreDataManager: CoreDataManageable = CoreDataManager(withContainerName: CoreDataContainerNames.generic)) {
        self.coreDataManager = coreDataManager
    }
    
    override func job(completion: @escaping ((Result<BankModels.User, GetUserLocalWorkerError>) -> Void)) {
        
        coreDataManager.performBackgroundTask { [weak self] (context) in
            guard let self = self else { return }
            
            var mapped: BankModels.User?
            let fetchRequest: NSFetchRequest = NSFetchRequest<MOUser>(entityName: MOUser.entityName)
            if let mo = (try? context.fetch(fetchRequest))?.first {
                mapped = BankModels.User.convert(from: mo)
            }
            
            if let profile = mapped {
                completion(.success(profile))
            } else {
                completion(.failure(.retrievingUserError))
            }
        }
    }
}
