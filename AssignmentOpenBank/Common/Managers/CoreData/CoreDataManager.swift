//
//  CoreDataManager.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 29/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataManager: CoreDataManageable {
    var containerName: ContainerName
    
    init(withContainerName containerName: ContainerName) {
        self.containerName = containerName
    }
    
}
