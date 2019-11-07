//
//  ReadableSpanMock.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 06/11/2019.
//

@testable import OpenTelemetrySwift
import Foundation

class ReadableSpanMock: ReadableSpan {

    var name: String = "ReadableSpanMock"

    func toSpanData() -> SpanData {
        return SpanData(traceId: context.traceId, spanId: context.spanId, traceFlags: context.traceFlags, tracestate: Tracestate(), parentSpanId: nil, resource: Resource(labels: [String:String]()), name: "ReadableSpanMock", kind: .client, timestamp: Timestamp(), status: nil, endTimestamp: Timestamp())
    }

    var context: SpanContext = SpanContext(traceId: TraceId.random(), spanId: SpanId.random(), traceFlags: TraceFlags())

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

    func addEvent(name: String, attributes: [String : AttributeValue]) {

    }

    func addEvent<E>(event: E) where E : Event {

    }

    func end() {

    }

    func end(timestamp: Timestamp) {

    }

    var description: String = "ReadableSpanMock"


}
