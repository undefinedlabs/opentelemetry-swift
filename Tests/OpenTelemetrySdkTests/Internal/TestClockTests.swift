//
//  TextClockTests.swift
//
//  Created by Ignacio Bonafonte on 06/11/2019.
//

@testable import OpenTelemetrySdk
import XCTest

class TestClockTests: XCTestCase {
    func testSetAndGetTime() {
        let clock = TestClock(nanos: 1234)
        XCTAssertEqual(clock.now, 1234)
        clock.setTime(nanos: 9876543210)
        XCTAssertEqual(clock.now, 9876543210)
    }

    func testAdvanceMillis() {
        let clock = TestClock(nanos: 1_500_000_000)
        clock.advanceMillis(2600)
        XCTAssertEqual(clock.now, 4_100_000_000)
    }

    func testMeasureElapsedTime() {
        let clock = TestClock(nanos: 10_000_000_001)
        let nanos1 = clock.nanoTime
        clock.setTime(nanos:11_000_000_005)
        let nanos2 = clock.nanoTime
        XCTAssertEqual(nanos2 - nanos1, 1_000_000_004)
    }
}
