//
//  TextClockTests.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 06/11/2019.
//

@testable import OpenTelemetrySwift
import XCTest

class TestClockTests: XCTestCase {
    func testSetAndGetTime() {
        let clock = TestClock(timestamp: ClockTestUtil.createTimestamp(seconds: 1, nanos: 2))
        XCTAssertEqual(clock.now, ClockTestUtil.createTimestamp(seconds: 1, nanos: 2))
        clock.setTime(timestamp: ClockTestUtil.createTimestamp(seconds: 3, nanos: 4))
        XCTAssertEqual(clock.now, ClockTestUtil.createTimestamp(seconds: 3, nanos: 4))
    }

    func testAdvanceMillis() {
        let clock = TestClock(timestamp: ClockTestUtil.createTimestamp(seconds: 1, nanos: 500 * ClockTestUtil.nanosPerMilli))
        clock.advanceMillis(millis: 2600)
        XCTAssertEqual(clock.now, ClockTestUtil.createTimestamp(seconds: 4, nanos: 100 * ClockTestUtil.nanosPerMilli))
    }

    func testMeasureElapsedTime() {
        let clock = TestClock(timestamp: ClockTestUtil.createTimestamp(seconds: 10, nanos: 1))
        let nanos1 = clock.nowNanos
        clock.setTime(timestamp: ClockTestUtil.createTimestamp(seconds: 11, nanos: 5))
        let nanos2 = clock.nowNanos
        XCTAssertEqual(nanos2 - nanos1, ClockTestUtil.nanosPerSecond + 4)
    }
}
