//
//  GetBankAccountStateWorker.swift
//  AssignmentOpenBank
//
//  Created by pips on 18/04/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import Foundation
import CoreData

enum GetBankAccountStateWorkerError: Error {
    case retrievingUserError
}

enum GetBankAccountStateWorkerState: Error {
    case bankAccountRegistered
    case bankAccountNotRegistered
}

typealias GetBankAccountStateWorkerAlias = BaseWorker<Void, Result<GetBankAccountStateWorkerState, GetBankAccountStateWorkerError>>

final class GetBankAccountStateWorker: GetBankAccountStateWorkerAlias {
    
    private let coreDataManager: CoreDataManageable
    private let santanderTokenKeychain: CodableKeychain<SantanderModels.Token>
    
    init(coreDataManager: CoreDataManageable = CoreDataManager(withContainerName: CoreDataContainerNames.generic), santanderTokenKeychain: CodableKeychain<SantanderModels.Token> = SantanderPreAuthTokenKeychainBuilder.build()) {
        
        self.coreDataManager = coreDataManager
        self.santanderTokenKeychain = santanderTokenKeychain
        super.init()
    }
    
    override func job(completion: @escaping ((Result<GetBankAccountStateWorkerState, GetBankAccountStateWorkerError>) -> Void)) {
        
        coreDataManager.performBackgroundTask { [weak self] (context) in
            guard let self = self else { return }
            
            var mapped: BankModels.User?
            let fetchRequest: NSFetchRequest = NSFetchRequest<MOUser>(entityName: MOUser.entityName)
            if let mo = (try? context.fetch(fetchRequest))?.first {
                mapped = BankModels.User.convert(from: mo)
            }
            
            if let profile = mapped {
                if profile.bankAccounts.count > 0 {
                    let bankAccount = profile.bankAccounts[0]
                    
                    if let user = bankAccount.accountUser {
                        switch bankAccount.bank.kind {
                        case .santander:
                            if (try? self.santanderTokenKeychain.fetch(user: user).accessToken) != nil {
                                completion(.success(.bankAccountRegistered))
                            } else {
                                completion(.success(.bankAccountNotRegistered))
                            }
                        default:
                            completion(.success(.bankAccountNotRegistered))
                        }
                    } else {
                        
                    }
                } else {
                    completion(.success(.bankAccountNotRegistered))
                }
            } else {
                completion(.failure(.retrievingUserError))
            }
        }
    }
}
