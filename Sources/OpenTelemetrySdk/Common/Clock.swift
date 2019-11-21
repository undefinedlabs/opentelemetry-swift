//
//  Clock.swift
//
//  Created by Ignacio Bonafonte on 04/11/2019.
//

import Foundation
import OpenTelemetryApi

/// Interface for getting the current time.
public protocol Clock {

    /// Obtains the current epoch timestamp in nanos from this clock.
    var now: Int { get }

    /// Returns a time measurement with nanosecond precision that can only be used to calculate elapsed
    /// time.
    var nanoTime: Int { get }
}

public func == (lhs: Clock, rhs: Clock) -> Bool {
    return lhs.now == rhs.now && lhs.nanoTime == rhs.nanoTime
}
