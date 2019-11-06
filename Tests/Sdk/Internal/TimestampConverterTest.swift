//
//  TimestampConverterTest.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 06/11/2019.
//
@testable import OpenTelemetrySwift
import XCTest

class TimestampConverterTest: XCTestCase {
    private let timestamp = Timestamp(fromMillis: 1234, nanoseconds: 5678)
    private var testClock: TestClock!

    override func setUp() {
        testClock = TestClock(timestamp: timestamp)
    }

    func testNow() {
        XCTAssertEqual(testClock.now, timestamp)
        let timeConverter = TimestampConverter.now(clock: testClock)
        XCTAssertEqual(timeConverter.convertNanoTime(nanoTime: testClock.nowNanos), timestamp)
    }

    func testConvertNanoTime_Positive() {
        let timeConverter = TimestampConverter.now(clock: testClock)
        XCTAssertEqual(timeConverter.convertNanoTime(nanoTime: testClock.nowNanos + 3210), Timestamp(fromMillis: 1234, nanoseconds: 8888))
        XCTAssertEqual(timeConverter.convertNanoTime(nanoTime: testClock.nowNanos + 1000), Timestamp(fromMillis: 1234, nanoseconds: 6678))
//        XCTAssertEqual(timeConverter.convertNanoTime(nanoTime: testClock.nowNanos + 15_999_994_322), Timestamp(fromMillis: 1250, nanoseconds: 0))
    }


    func testConvertNanoTime_Negative() {
        let timeConverter = TimestampConverter.now(clock: testClock)
        XCTAssertEqual(timeConverter.convertNanoTime(nanoTime: testClock.nowNanos - 3456), Timestamp(fromMillis: 1234, nanoseconds: 2222))
        XCTAssertEqual(timeConverter.convertNanoTime(nanoTime: testClock.nowNanos - 1000), Timestamp(fromMillis: 1234, nanoseconds: 4678))
//        XCTAssertEqual(timeConverter.convertNanoTime(nanoTime: testClock.nowNanos - 14000005678), Timestamp(fromMillis: 1220, nanoseconds: 0))
    }
}
