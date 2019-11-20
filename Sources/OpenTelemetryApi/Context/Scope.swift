//
//  Scope.swift
//
//
//  Created by Ignacio Bonafonte on 15/10/2019.
//

import Foundation

/// Represents a change to the current context over a scope of code.
public protocol Scope {
    /// Closes the current context
    mutating func close()
}
