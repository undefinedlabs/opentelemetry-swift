//
//  MonotonicClock.swift
//
//  Created by Ignacio Bonafonte on 18/11/2019.
//

import Foundation
import OpenTelemetryApi

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
