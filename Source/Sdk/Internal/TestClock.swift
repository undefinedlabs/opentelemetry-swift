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
      currentTimestamp = timestamp;
    }


    /**
     * Advances the time by millis and mutates this instance.
     *
     * @param millis the increase in time.
     * @since 0.1.0
     */
    func advanceMillis(millis: Int) {
        let incomingSeconds = Double(millis) / 1000

        currentTimestamp = Timestamp(timeInterval: currentTimestamp.timeInterval + incomingSeconds )
    }

    var now: Timestamp {
        return currentTimestamp
    }
}
