//
//  NSManagedObjectContext+Query.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 29/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    
    // MARK: Fetch
    
    func all<T>(entriesFor entity: T.Type, where predicate: NSPredicate? = nil, sort descriptor: NSSortDescriptor? = nil) -> [T] where T: NSManagedObject {
        let request = getRequest(for: entity)
        request.predicate = predicate
        if let desc = descriptor {
            request.sortDescriptors = [desc]
        }
        do {
            let entities = try fetch(request)
            return (entities as? [T]) ?? [] //If the casting fails, we return an empty array
        } catch {
            print(error.localizedDescription)
        }
        return []
    }
    
    func first<T>(entity: T.Type, where predicate: NSPredicate) -> T? where T: NSManagedObject {
        let request = getRequest(for: entity)
        request.predicate = predicate
        request.fetchLimit = 1
        do {
            return try fetch(request).first as? T
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    func first<T>(entity: T.Type, where condition: ((T) -> Bool)? ) -> T? where T: NSManagedObject {
        let entities = all(entriesFor: entity)
        if let condition = condition {
            return entities.first(where: condition)
        }
        return entities.first
    }
    
    // MARK: Delete
    
    func deleteAll<T>(entriesFor entity: T.Type) where T: NSManagedObject {
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: getRequest(for: entity))
        do {
            try execute(deleteRequest)
        } catch {
            print(error.localizedDescription)
            assertionFailure(error.localizedDescription)
        }
    }
    
    // MARK: Private
    
    private func getRequest<T>(for entity: T.Type) -> NSFetchRequest<NSFetchRequestResult> where T: NSManagedObject {
        return NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
    }
}
