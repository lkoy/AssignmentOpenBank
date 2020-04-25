//
//  DataConvertible.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 02/01/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import Foundation
import CoreData

typealias DataConvertible = CoreDataConvertible & DomainDataConvertible

protocol CoreDataConvertible {
    associatedtype ManagedObject: NSManagedObject
    
    func convert(in context: NSManagedObjectContext) -> ManagedObject?
    func convert(to base: ManagedObject) -> ManagedObject?
}

extension CoreDataConvertible {
    
    @discardableResult
    func convert(in context: NSManagedObjectContext) -> ManagedObject? {
        let mO = ManagedObject(context: context)
        return convert(to: mO)
    }
    
}

protocol DomainDataConvertible {
    associatedtype ManagedObject: NSManagedObject
    
    static func convert(from managedObject: ManagedObject) -> Self?
}
