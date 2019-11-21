//
//  MonotonicClock.swift
//
//  Created by Ignacio Bonafonte on 18/11/2019.
//

import Foundation
import OpenTelemetryApi

/// This class provides a mechanism for calculating the epoch time using Date().timeIntervalSince1970
/// and a reference epoch timestamp.
/// This clock needs to be re-created periodically in order to re-sync with the kernel clock, and
/// it is not recommended to use only one instance for a very long period of time.
public class MonotonicClock: Clock {

    let clock: Clock
    let epochNanos: Int
    let initialNanoTime: Int

    public init(clock:Clock) {
        self.clock = clock
        self.epochNanos = clock.now
        self.initialNanoTime = clock.nanoTime
    }

    public var now: Int {
        let deltaNanos = clock.nanoTime - self.initialNanoTime
        return epochNanos + deltaNanos
    }

    public var nanoTime: Int {
        return clock.nanoTime
    }

}
