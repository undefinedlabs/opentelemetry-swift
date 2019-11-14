//
//  DefaultSpanTest.swift
//
//
//  Created by Ignacio Bonafonte on 22/10/2019.
//

@testable import OpenTelemetrySwift
import XCTest

final class DefaultSpanTest: XCTestCase {
    func testHasInvalidContextAndDefaultSpanOptions() {
        let context = DefaultSpan.random().context
        XCTAssertEqual(context.traceFlags, TraceFlags())
        XCTAssertEqual(context.tracestate, Tracestate())
    }

    func testHasUniqueTraceIdAndSpanId() {
        let span1 = DefaultSpan.random()
        let span2 = DefaultSpan.random()
        XCTAssertNotEqual(span1.context.traceId, span2.context.traceId)
        XCTAssertNotEqual(span1.context.spanId, span2.context.spanId)
    }

    func testDoNotCrash() {
        let span = DefaultSpan.random()
        span.setAttribute(key: "MyStringAttributeKey", value: AttributeValue.string("MyStringAttributeValue"))
        span.setAttribute(key: "MyBooleanAttributeKey", value: AttributeValue.bool(true))
        span.setAttribute(key: "MyLongAttributeKey", value: AttributeValue.int(123))
        span.addEvent(name: "event")
        span.addEvent(name: "event", attributes: ["MyBooleanAttributeKey": AttributeValue.bool(true)])
        span.addEvent(event: SimpleEvent(name: "event"))

        span.status = .ok
        span.end()
        span.end(timestamp: Timestamp())
    }

    func testDefaultSpan_ToString() {
        let span = DefaultSpan.random()
        XCTAssertEqual(span.description, "DefaultSpan")
    }

    func testDefaultSpan_NullEndSpanOptions() {
        let span = DefaultSpan()
        span.end()
    }
}
