//
//  TestClock.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 05/11/2019.
//

import Foundation

class TestClock: Clock {
    var currentTimestamp: Timestamp

    init(timestamp: Timestamp) {
        currentTimestamp = timestamp
    }

    convenience init() {
        self.init(timestamp: Timestamp(fromMillis: 1557212400000))
    }

    /**
     * Sets the time.
     *
     * @param timestamp the new time.
     * @since 0.1.0
     */
    func setTime(timestamp: Timestamp) {
        currentTimestamp = timestamp
    }

    /**
     * Advances the time by millis and mutates this instance.
     *
     * @param millis the increase in time.
     * @since 0.1.0
     */
    func advanceMillis(millis: Int) {
        let incomingSeconds = millis / 1000
        let remainingMillis = millis % 1000
        let remainingNanos = remainingMillis * TimestampConverter.nanosPerMilli

        var newSeconds = incomingSeconds + currentTimestamp.seconds
        var newNanos = remainingNanos + currentTimestamp.nanos

        if newNanos >= TimestampConverter.nanosPerSecond {
            newSeconds += newNanos / TimestampConverter.nanosPerSecond
            newNanos = newNanos % TimestampConverter.nanosPerSecond
        }
        currentTimestamp = Timestamp(seconds: newSeconds, nanos: newNanos)
    }

    var now: Timestamp {
        return currentTimestamp
    }

    var nowNanos: Int {
        return (currentTimestamp.seconds * TimestampConverter.nanosPerSecond) + currentTimestamp.nanos
    }
}
