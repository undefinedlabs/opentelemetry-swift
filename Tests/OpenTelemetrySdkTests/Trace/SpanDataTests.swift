//
//  SpanDataTests.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 07/11/2019.
//

@testable import OpenTelemetrySdk
import OpenTelemetryApi
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
        return SpanData(traceId: TraceId(), spanId: SpanId(), traceFlags: TraceFlags(), tracestate: Tracestate(), resource: Resource(), name: "spanName", kind: .server, timestamp: Timestamp(seconds: 3001, nanos: 255), endTimestamp: Timestamp(seconds: 3001, nanos: 255))
    }
}
