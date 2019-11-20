//
//  MonotonicClockTests.swift
//
//  Created by Ignacio Bonafonte on 18/11/2019.
//

import XCTest
//import OpenTelemetryApi
@testable import OpenTelemetrySdk

class MonotonicClockTests: XCTestCase {

    let epochNanos: Int = 1234_000_005_678
    var testClock: TestClock! = nil

    override func setUp() {
        testClock = TestClock(nanos:epochNanos);
    }

    func testNanoTime() {
        XCTAssertEqual(testClock.now, epochNanos)
        let monotonicClock = MonotonicClock(clock: testClock);
        XCTAssertEqual(monotonicClock.nanoTime, testClock.nanoTime)
        testClock.advanceNanos(12345);
        XCTAssertEqual(monotonicClock.nanoTime, testClock.nanoTime)
    }

    func testNow_PositiveIncrease() {
        let monotonicClock = MonotonicClock(clock: testClock);
        XCTAssertEqual(monotonicClock.now, testClock.now)
        testClock.advanceNanos(3210);
        XCTAssertEqual(monotonicClock.now, 1234_000_008_888)
        // Initial + 1000
        testClock.advanceNanos(-2210);
        XCTAssertEqual(monotonicClock.now, 1234_000_006_678)
        testClock.advanceNanos(15_999_993_322);
        XCTAssertEqual(monotonicClock.now, 1250_000_000_000)
    }

    func testNow_NegativeIncrease() {
        let monotonicClock = MonotonicClock(clock: testClock);
        XCTAssertEqual(monotonicClock.now, testClock.now)
        testClock.advanceNanos(-3456);
        XCTAssertEqual(monotonicClock.now, 1234_000_002_222)
        // Initial - 1000
        testClock.advanceNanos(2456);
        XCTAssertEqual(monotonicClock.now, 1234_000_004_678)
        testClock.advanceNanos(-14_000_004_678);
        XCTAssertEqual(monotonicClock.now, 1220_000_000_000)

    }
}
