//
//  MillisClock.swift
//
//  Created by Ignacio Bonafonte on 05/11/2019.
//

import Foundation
import OpenTelemetryApi


/// A Clock that uses Date().timeIntervalSince1970 .
public class MillisClock: Clock {

    ///  Returns a MillisClock
    public init() {
    }

    public var now: Int {
        return Int(Date().timeIntervalSince1970 * 1000000000)
    }

    public var nanoTime: Int {
        return Int(Date().timeIntervalSince1970 * 1000000000)
    }
}
