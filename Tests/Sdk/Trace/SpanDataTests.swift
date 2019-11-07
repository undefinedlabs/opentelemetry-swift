//
//  SpanDataTests.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 07/11/2019.
//
@testable import OpenTelemetrySwift
import XCTest

class SpanDataTests: XCTestCase {

    func testdefaultValues() {
        let spanData = createBasicSpan()
        XCTAssertNil(spanData.parentSpanId)
        XCTAssertEqual(spanData.attributes, [String: AttributeValue]())
        XCTAssertEqual(spanData.timedEvents, [TimedEvent]())
        XCTAssertEqual(spanData.links.count, 0)
    }

    private func createBasicSpan() -> SpanData {
        return SpanData(traceId: TraceId(), spanId: SpanId(), traceFlags: TraceFlags(), tracestate: Tracestate(), resource: Resource(), name: "spanName", kind: .server, timestamp: Timestamp(fromSeconds: 3001, nanoseconds: 255), endTimestamp: Timestamp(fromSeconds: 3001, nanoseconds: 255))
    }
}
