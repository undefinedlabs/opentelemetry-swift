//
//  TestClock.swift
//
//  Created by Ignacio Bonafonte on 05/11/2019.
//

import Foundation
import OpenTelemetryApi

/// A mutable Clock that allows the time to be set for testing.
class TestClock: Clock {
    var currentEpochNanos: Int

    /// Creates a clock with the given time.
    /// - Parameter nanos: the initial time in nanos since epoch.
    init(nanos: Int) {
        currentEpochNanos = nanos
    }


    /// Creates a clock initialized to a constant non-zero time
    convenience init() {
        self.init(nanos: 1557212400000 * 1000)
    }

    ///  Sets the time.
    /// - Parameter nanos: the new time.
    func setTime(nanos: Int) {
        currentEpochNanos = nanos
    }

    /// Advances the time by millis and mutates this instance.
    /// - Parameter millis: the increase in time.
    func advanceMillis(_ millis: Int) {
        currentEpochNanos += millis * 1_000_000
    }

    /// Advances the time by nanos and mutates this instance.
    /// - Parameter nanos: the increase in time
    func advanceNanos(_ nanos: Int) {
        currentEpochNanos += nanos
    }

    var now: Int {
        return currentEpochNanos
    }

    var nanoTime: Int {
        return currentEpochNanos
    }
}
