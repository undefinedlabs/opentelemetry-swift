//
//  TimestampConverterTest.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 06/11/2019.
//
@testable import OpenTelemetrySdk
import OpenTelemetryApi
import XCTest

class TimestampConverterTest: XCTestCase {
    private let timestamp = Timestamp(seconds: 1234, nanos: 5678)
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
        XCTAssertEqual(timeConverter.convertNanoTime(nanoTime: testClock.nowNanos + 3210), Timestamp(seconds: 1234, nanos: 8888))
        XCTAssertEqual(timeConverter.convertNanoTime(nanoTime: testClock.nowNanos + 1000), Timestamp(seconds: 1234, nanos: 6678))
        XCTAssertEqual(timeConverter.convertNanoTime(nanoTime: testClock.nowNanos + 15999994322), Timestamp(seconds: 1250, nanos: 0))
    }

    func testConvertNanoTime_Negative() {
        let timeConverter = TimestampConverter.now(clock: testClock)
        XCTAssertEqual(timeConverter.convertNanoTime(nanoTime: testClock.nowNanos - 3456), Timestamp(seconds: 1234, nanos: 2222))
        XCTAssertEqual(timeConverter.convertNanoTime(nanoTime: testClock.nowNanos - 1000), Timestamp(seconds: 1234, nanos: 4678))
        XCTAssertEqual(timeConverter.convertNanoTime(nanoTime: testClock.nowNanos - 14000005678), Timestamp(seconds: 1220, nanos: 0))
    }
}
