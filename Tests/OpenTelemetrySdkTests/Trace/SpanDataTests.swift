//
//  SpanDataTests.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 07/11/2019.
//

import OpenTelemetryApi
@testable import OpenTelemetrySdk
import XCTest

class SpanDataTests: XCTestCase {
    let startEpochNanos: Int = 3000000000000 + 200
    let endEpochNanos: Int = 3001000000000 + 255

    func testdefaultValues() {
        let spanData = createBasicSpan()
        XCTAssertNil(spanData.parentSpanId)
        XCTAssertEqual(spanData.attributes, [String: AttributeValue]())
        XCTAssertEqual(spanData.timedEvents, [SpanData.TimedEvent]())
        XCTAssertEqual(spanData.links.count, 0)
        XCTAssertEqual(InstrumentationLibraryInfo(), spanData.instrumentationLibraryInfo)
        XCTAssertFalse(spanData.hasRemoteParent)
    }

    private func createBasicSpan() -> SpanData {
        return SpanData(traceId: TraceId(),
                        spanId: SpanId(),
                        traceFlags: TraceFlags(),
                        tracestate: Tracestate(),
                        resource: Resource(),
                        instrumentationLibraryInfo: InstrumentationLibraryInfo(),
                        name: "spanName",
                        kind: .server,
                        startEpochNanos: startEpochNanos,
                        endEpochNanos: endEpochNanos,
                        hasRemoteParent: false)
    }
}
