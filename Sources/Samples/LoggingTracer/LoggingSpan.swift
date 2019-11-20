//
//  LoggingSpan.swift
//
//  Created by Ignacio Bonafonte on 19/11/2019.
//

import Foundation
import OpenTelemetryApi

class LoggingSpan: Span {
    var name: String
    var kind: SpanKind
    var context: SpanContext = SpanContext.invalid
    var isRecordingEvents: Bool = true
    var status: Status?

    public init(name: String, kind: SpanKind) {
        self.name = name
        self.kind = kind
    }

    public var description: String {
        return name
    }

    public func updateName(name: String) {
        Logger.log("Span.updateName(\(name))")
        self.name = name
    }

    public func setAttribute(key: String, value: String) {
        Logger.log("Span.setAttribute(key: \(key), value: \(value))")
    }

    public func setAttribute(key: String, value: Int) {
        Logger.log("Span.setAttribute(key: \(key), value: \(value))")
    }

    public func setAttribute(key: String, value: Double) {
        Logger.log("Span.setAttribute(key: \(key), value: \(value))")
    }

    public func setAttribute(key: String, value: Bool) {
        Logger.log("Span.setAttribute(key: \(key), value: \(value))")
    }

    public func setAttribute(key: String, value: AttributeValue) {
        Logger.log("Span.setAttribute(key: \(key), value: \(value))")
    }

    public func setAttribute(keyValuePair: (String, AttributeValue)) {
        Logger.log("Span.SetAttributes(keyValue: \(keyValuePair))")
        setAttribute(key: keyValuePair.0, value: keyValuePair.1)
    }

    public func addEvent(name: String) {
        Logger.log("Span.addEvent(\(name))")
    }

    public func addEvent(name: String, timestamp: Int) {
        Logger.log("Span.addEvent(\(name) timestamp:\(timestamp))")
    }

    public func addEvent(name: String, attributes: [String: AttributeValue]) {
        Logger.log("Span.addEvent(\(name), attributes:\(attributes) )")
    }

    public func addEvent(name: String, attributes: [String: AttributeValue], timestamp: Int) {
        Logger.log("Span.addEvent(\(name), attributes:\(attributes), timestamp:\(timestamp))")
    }

    public func addEvent<E>(event: E) where E: Event {
        Logger.log("Span.addEvent(\(event))")
    }

    public func addEvent<E>(event: E, timestamp: Int) where E: Event {
        Logger.log("Span.addEvent(\(event), timestamp:\(timestamp))")
    }

    public func addLink(link: Link) {
        Logger.log("Span.addLink(\(link))")
    }

    public func end() {
        Logger.log("Span.End, Name: \(name)")
    }

    public func end(endOptions: EndSpanOptions) {
        Logger.log("Span.End, Name: \(name), timestamp:\(endOptions.timestamp)) }")
    }
}
