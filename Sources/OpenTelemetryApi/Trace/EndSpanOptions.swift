//
//  EndSpanOptions.swift
//
//  Created by Ignacio Bonafonte on 14/10/2019.
//

import Foundation

/// A struct that enables overriding the default values used when ending a Span. Allows
/// overriding the endTimestamp.
public struct EndSpanOptions {
    /// The end timestamp
    public var timestamp: Int = 0
}
