//
//  String+Optional.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 16/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

import Foundation

infix operator ???

public func ???<T> (optional: T?, defaultValue: @autoclosure () -> String) -> String {
    return optional.map { String(describing: $0) } ?? defaultValue()
}
