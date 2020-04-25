//
//  LOTTiming.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 11/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

import Foundation

public struct LOTTiming {
    
    let inFrames: InFrames
    let loopFrames: LoopFrames
    
    struct InFrames {
        let from: NSNumber = 0
        let to: NSNumber
    }
    
    struct LoopFrames {
        let from: NSNumber
        let to: NSNumber
    }
    
}
