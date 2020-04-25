//
//  NSManageObject+Utils.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 29/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {
    
    static var entityName: String { return String(describing: self) }

}
