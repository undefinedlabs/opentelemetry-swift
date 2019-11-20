//
//  TestClock.swift
//
//  Created by Ignacio Bonafonte on 05/11/2019.
//

import Foundation
import OpenTelemetryApi

class TestClock: Clock {
    var currentEpochNanos: Int

    init(nanos: Int) {
        currentEpochNanos = nanos
    }

    convenience init() {
        self.init(nanos: 1557212400000 * 1000)
    }

    /**
     * Sets the time.
     *
     * @param timestamp the new time.
     * @since 0.1.0
     */
    func setTime(nanos: Int) {
        currentEpochNanos = nanos
    }

    /**
     * Advances the time by millis and mutates this instance.
     *
     * @param millis the increase in time.
     * @since 0.1.0
     */

    func advanceMillis(_ millis: Int) {
        currentEpochNanos += millis * 1_000_000
    }

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
