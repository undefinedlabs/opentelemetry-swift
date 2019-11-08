//
//  SpanMock.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 07/11/2019.
//

import Foundation
@testable import OpenTelemetrySwift

class SpanMock: Span {

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

       func addEvent(name: String, attributes: [String: AttributeValue]) {
       }

       func addEvent<E>(event: E) where E: Event {
       }

       func end() {
       }

       func end(timestamp: Timestamp) {
       }

       var description: String = "SpanMock"
}
