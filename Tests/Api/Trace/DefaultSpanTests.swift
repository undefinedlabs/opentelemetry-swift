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
        let context = DefaultSpan.createRandom().context
        XCTAssertEqual(context.traceFlags, TraceFlags())
        XCTAssertEqual(context.tracestate, Tracestate())
    }

    func testHasUniqueTraceIdAndSpanId() {
        let span1 = DefaultSpan.createRandom()
        let span2 = DefaultSpan.createRandom()
        XCTAssertNotEqual(span1.context.traceId, span2.context.traceId)
        XCTAssertNotEqual(span1.context.spanId, span2.context.spanId)
    }

    func testDoNotCrash() {
        let span = DefaultSpan.createRandom()
        span.setAttribute( key: "MyStringAttributeKey", value: AttributeValue.string("MyStringAttributeValue"))
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
        let span = DefaultSpan.createRandom()
        XCTAssertEqual(span.description, "DefaultSpan")
    }

    func testDefaultSpan_NullEndSpanOptions() {
        let span = DefaultSpan()
        span.end()
    }
}
