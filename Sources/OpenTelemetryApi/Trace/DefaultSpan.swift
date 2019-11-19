//
//  DefaultSpan.swift
//
//
//  Created by Ignacio Bonafonte on 15/10/2019.
//

import Foundation

public class DefaultSpan: Span {

    public var context: SpanContext

    public init() {
        context = SpanContext.invalid
    }

    public init(context: SpanContext) {
        self.context = context
    }

    public static func random() -> DefaultSpan {
        return DefaultSpan(context: SpanContext.create(traceId: TraceId.random(), spanId: SpanId.random(), traceFlags: TraceFlags(), tracestate: Tracestate()))
    }

    public var isRecordingEvents: Bool {
        return false
    }

    public var status: Status? {
        get {
            return Status.ok
        }
        set {
        }
    }

    public var description: String {
        return "DefaultSpan"
    }

    public func updateName(name: String) {
    }

    public func setAttribute(key: String, value: String) {
    }

    public func setAttribute(key: String, value: Int) {
    }

    public func setAttribute(key: String, value: Double) {
    }

    public func setAttribute(key: String, value: Bool) {
    }

    public func setAttribute(key: String, value: AttributeValue) {
    }

    public func addEvent(name: String) {
    }

    public func addEvent(name: String, timestamp: Int) {
    }

    public func addEvent(name: String, attributes: [String: AttributeValue]) {
    }

    public func addEvent(name: String, attributes: [String : AttributeValue], timestamp: Int) {
    }

    public func addEvent<E>(event: E) where E: Event {
    }

    public func addEvent<E>(event: E, timestamp: Int) where E : Event {

    }
    public func addLink(link: Link) {
    }

    public func end() {
    }

    public func end(endOptions: EndSpanOptions) {
    }
}
