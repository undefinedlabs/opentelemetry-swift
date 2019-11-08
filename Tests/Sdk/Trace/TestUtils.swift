//
//  TestUtils.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 07/11/2019.
//
@testable import OpenTelemetrySwift
import Foundation

struct TestUtils {
    static func generateRandomAttributes() -> [String: AttributeValue] {
        var result = [String: AttributeValue]()
        let name = UUID().uuidString
        let attribute = AttributeValue.string(UUID().uuidString)
        result[name] = attribute
        return result
    }

    static func makeBasicSpan() -> SpanData {
        return SpanData(traceId: TraceId(), spanId: SpanId(), traceFlags: TraceFlags(), tracestate: Tracestate(), resource: Resource(), name: "spanName", kind: .server, timestamp: Timestamp(fromSeconds: 3001, nanoseconds: 255), endTimestamp: Timestamp(fromSeconds: 3001, nanoseconds: 255))
    }
}
