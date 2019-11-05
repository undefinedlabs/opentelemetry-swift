//
//  DefaultSpan.swift
//
//
//  Created by Ignacio Bonafonte on 15/10/2019.
//

import Foundation

class DefaultSpan: Span {
    var context: SpanContext

    init() {
        context = SpanContext.invalid
    }

    init(context: SpanContext) {
        self.context = context
    }

    static func createRandom() -> DefaultSpan {
        return DefaultSpan(context: SpanContext(traceId: TraceId.createRandom(), spanId: SpanId.createRandom(), traceFlags: TraceFlags(), tracestate: Tracestate()))
    }

    var IsRecordingEvents: Bool {
        return false
    }

    var status: Status? {
        get {
            return Status.ok
        }
        set {
            
        }
    }

    var description: String {
        return "DefaultSpan"
    }

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

    func addLink(link: Link) {
    }

    func end() {
    }

    func end(timestamp: Timestamp) {
    }
}
