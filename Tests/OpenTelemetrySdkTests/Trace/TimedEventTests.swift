//
//  TimedEventTests.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 07/11/2019.
//

@testable import OpenTelemetrySdk
import OpenTelemetryApi
import XCTest

class TimedEventTests: XCTestCase {
    struct TestEvent: Event {
        var name = TimedEventTests.eventName2
        var attributes = TimedEventTests.attributes2
    }

    static let eventName = "event"
    static let eventName2 = "event2"
    static let attributes = ["attribute": AttributeValue.string("value")]
    static let attributes2 = ["attribute2": AttributeValue.string("value2")]
    let testEvent = TestEvent()

    func testRawTimedEventWithName() {
        let event = TimedEvent(nanotime: 1000, name: TimedEventTests.eventName)
        XCTAssertEqual(event.epochNanos, 1000)
        XCTAssertEqual(event.name, TimedEventTests.eventName)
        XCTAssertEqual(event.attributes.count, 0)
    }

    func testRawTimedEventWithNameAndAttributes() {
        let event = TimedEvent(nanotime: 2000, name: TimedEventTests.eventName, attributes: TimedEventTests.attributes)
        XCTAssertEqual(event.epochNanos, 2000)
        XCTAssertEqual(event.name, TimedEventTests.eventName)
        XCTAssertEqual(event.attributes, TimedEventTests.attributes)
    }

    func testTimedEventWithEvent() {
        let event = TimedEvent(nanotime: 3000, event: testEvent)
        XCTAssertEqual(event.epochNanos, 3000)
        XCTAssertEqual(event.name, TimedEventTests.eventName2)
        XCTAssertEqual(event.attributes, TimedEventTests.attributes2)
    }
}
