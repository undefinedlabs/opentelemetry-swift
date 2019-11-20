//
//  ReadableSpanMock.swift
//
//  Created by Ignacio Bonafonte on 06/11/2019.
//

import Foundation
import OpenTelemetryApi
@testable import OpenTelemetrySdk

class ReadableSpanMock: ReadableSpan {

    var kind: SpanKind {
        return .client
    }

    var instrumentationLibraryInfo: InstrumentationLibraryInfo = InstrumentationLibraryInfo()

    var name: String = "ReadableSpanMock"

    var forcedReturnSpanContext: SpanContext?
    var forcedReturnSpanData: SpanData?

    func toSpanData() -> SpanData {
        return forcedReturnSpanData ?? SpanData(traceId: context.traceId,
                                                spanId: context.spanId,
                                                traceFlags: context.traceFlags,
                                                tracestate: Tracestate(),
                                                resource: Resource(labels: [String: String]()),
                                                instrumentationLibraryInfo: InstrumentationLibraryInfo(),
                                                name: "ReadableSpanMock",
                                                kind: .client,
                                                startEpochNanos: 0,
                                                endEpochNanos: 0,
                                                hasRemoteParent: false)
    }

    var context: SpanContext {
        forcedReturnSpanContext ?? SpanContext.create(traceId: TraceId.random(), spanId: SpanId.random(), traceFlags: TraceFlags(), tracestate: Tracestate())
    }

    var isRecordingEvents: Bool = false

    var status: Status?

    func updateName(name: String) {
    }

    func setAttribute(key: String, value: String) {
    }

    func setAttribute(key: String, value: Int) {
    }

    func setAttribute(key: String, value: Double) {
    }

    func setAttribute(key: String, value: Bool) {
    }

    func setAttribute(key: String, value: AttributeValue) {
    }

    func addEvent(name: String) {
    }

    func addEvent(name: String, attributes: [String: AttributeValue]) {
    }

    func addEvent<E>(event: E) where E: Event {
    }

    func addEvent(name: String, timestamp: Int) {
    }

    func addEvent(name: String, attributes: [String: AttributeValue], timestamp: Int) {
    }

    func addEvent<E>(event: E, timestamp: Int) where E: Event {
    }

    func end() {
    }

    func end(endOptions: EndSpanOptions) {
    }

    var description: String = "ReadableSpanMock"
}
