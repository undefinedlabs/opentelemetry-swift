//
//  TestUtils.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 07/11/2019.
//

@testable import Sdk
import Api
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
        return SpanData(traceId: TraceId(), spanId: SpanId(), traceFlags: TraceFlags(), tracestate: Tracestate(), resource: Resource(), name: "spanName", kind: .server, timestamp: Timestamp(seconds: 3001, nanos: 255), endTimestamp: Timestamp(seconds: 3001, nanos: 255))
    }
}
