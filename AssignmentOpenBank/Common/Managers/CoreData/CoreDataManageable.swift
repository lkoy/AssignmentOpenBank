//
//  CoreDataManageable.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 29/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

import Foundation
import CoreData

typealias ContainerName = String
enum CoreDataContainerNames {
    static let generic: ContainerName = "AssignmentOpenBank"
}

protocol CoreDataManageable {
    
    var containerName: String { get set }
    static var protectionLevel: URLFileProtection { get }
    var persistentContainer: NSPersistentContainer { get }
    init(withContainerName containerName: ContainerName)
    
    func saveContext()
    func performBackgroundTask(block: @escaping (NSManagedObjectContext) -> Void)
}

extension CoreDataManageable {
    
    static var protectionLevel: URLFileProtection { return .complete }
    
    var persistentContainer: NSPersistentContainer {
        let container = NSPersistentContainer(name: self.containerName)
        container.loadPersistentStores(completionHandler: { (descriptor, error) in
            guard let url = descriptor.url else {
                print("Error building NSPersistentStoreDescription or obtaining its url")
                return
            }
            
            if let error = error as NSError? {
                print("Error loading persistent stores: \(error)")
                if FileManager.default.fileExists(atPath: url.path) && error.code == 134140 {
                    do {
                        try FileManager.default.removeItem(at: url)
                        //Should we track in NR probably that we couldnt open the DB?
                        container.persistentStoreCoordinator.addPersistentStore(with: descriptor, completionHandler: { (_, error) in
                            if let error = error {
                                print("Error adding persistent store: \(error.localizedDescription)")
                            }
                        })
                    } catch {
                        print("Couldnt remove file \(error.localizedDescription)")
                    }
                }
            }
            
            descriptor.shouldInferMappingModelAutomatically = true
            descriptor.shouldMigrateStoreAutomatically = true
            
            do {
                try (url as NSURL).setResourceValue(Self.protectionLevel, forKey: .fileProtectionKey)
            } catch {
                // Couldnt set the fileProtection key, why? Explore error xD
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
            
        })
        return container
    }
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                //fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func performBackgroundTask(block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask(block)
    }
}
