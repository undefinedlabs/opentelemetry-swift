//
//  TimestampTests.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 08/11/2019.
//
@testable import OpenTelemetrySwift
import XCTest

class TimestampTests: XCTestCase {
    func testTimestampCreate() {
        XCTAssertEqual(Timestamp(seconds: 24, nanos: 42).seconds, 24)
        XCTAssertEqual(Timestamp(seconds: 24, nanos: 42).nanos, 42)
        XCTAssertEqual(Timestamp(seconds: -24, nanos: 42).seconds, -24)
        XCTAssertEqual(Timestamp(seconds: -24, nanos: 42).nanos, 42)
        XCTAssertEqual(Timestamp(seconds: 315576000000, nanos: 999999999).seconds, 315576000000)
        XCTAssertEqual(Timestamp(seconds: 315576000000, nanos: 999999999).nanos, 999999999)
        XCTAssertEqual(Timestamp(seconds: -315576000000, nanos: 999999999).seconds, -315576000000)
        XCTAssertEqual(Timestamp(seconds: -315576000000, nanos: 999999999).nanos, 999999999)
    }

    func testCreate_SecondsTooLow() {
        XCTAssertEqual(Timestamp(seconds: -315576000001, nanos: 0).seconds, -315576000000)
    }

    func testCreate_SecondsTooHigh() {
        XCTAssertEqual(Timestamp(seconds: 315576000001, nanos: 0).seconds, 315576000000)
    }

    func testCreate_NanosTooLow_PositiveTime() {
        XCTAssertEqual(Timestamp(seconds: 1, nanos: -1), Timestamp(seconds: 1, nanos: 0))
    }

    func testCreate_NanosTooHigh_PositiveTime() {
        XCTAssertEqual(Timestamp(seconds: 1, nanos: 1000000000), Timestamp(seconds: 1, nanos: 999999999))
    }

    func testCreate_NanosTooLow_NegativeTime() {
        XCTAssertEqual(Timestamp(seconds: -1, nanos: -1), Timestamp(seconds: -1, nanos: 0))
    }

    func testCreate_NanosTooHigh_NegativeTime() {
        XCTAssertEqual(Timestamp(seconds: -1, nanos: 1000000000), Timestamp(seconds: -1, nanos: 999999999))
    }

    func testTimestampFromMillis() {
        XCTAssertEqual(Timestamp(fromMillis: 0), Timestamp(seconds: 0, nanos: 0))
        XCTAssertEqual(Timestamp(fromMillis: 987), Timestamp(seconds: 0, nanos: 987000000))
        XCTAssertEqual(Timestamp(fromMillis: 3456), Timestamp(seconds: 3, nanos: 456000000))
    }

    func testTimestampFromMillis_Negative() {
        XCTAssertEqual(Timestamp(fromMillis: -1), Timestamp(seconds: -1, nanos: 999000000))
        XCTAssertEqual(Timestamp(fromMillis: -999), Timestamp(seconds: -1, nanos: 1000000))
        XCTAssertEqual(Timestamp(fromMillis: -3456), Timestamp(seconds: -4, nanos: 544000000))
    }

    func testFromMillis_TooLow() {
        XCTAssertEqual(Timestamp(fromMillis: -315576000001000).seconds, -315576000000)
    }

    func testFromMillis_TooHigh() {
        XCTAssertEqual(Timestamp(fromMillis: 315576000001000).seconds, 315576000000)
    }

    func testTimestamp_Equal() {
        // Positive tests.
        XCTAssertEqual(Timestamp(seconds: 0, nanos: 0), Timestamp(seconds: 0, nanos: 0))
        XCTAssertEqual(Timestamp(seconds: 24, nanos: 42), Timestamp(seconds: 24, nanos: 42))
        XCTAssertEqual(Timestamp(seconds: -24, nanos: 42), Timestamp(seconds: -24, nanos: 42))
        // Negative tests.
        XCTAssertNotEqual(Timestamp(seconds: 25, nanos: 42), Timestamp(seconds: 24, nanos: 42))
        XCTAssertNotEqual(Timestamp(seconds: 24, nanos: 43), Timestamp(seconds: 24, nanos: 42))
        XCTAssertNotEqual(Timestamp(seconds: -25, nanos: 42), Timestamp(seconds: -24, nanos: 42))
        XCTAssertNotEqual(Timestamp(seconds: -24, nanos: 43), Timestamp(seconds: -24, nanos: 42))
    }
}
