//
//  TestUtils.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 07/11/2019.
//
@testable import OpenTelemetrySwift
import Foundation

struct TestUtils {

    static func generateRandomAttributes() -> [String:AttributeValue] {
        var result = [String:AttributeValue]()
        let name = UUID().uuidString
        let attribute = AttributeValue.string(UUID().uuidString);
        result[name] = attribute
        return result
    }

//    static func makeBasicSpan() -> SpanData {
//        var result = SpanData(traceId: TraceId(), spanId: SpanId(), traceFlags: TraceFlags, tracestate: <#T##Tracestate#>, parentSpanId: <#T##SpanId?#>, resource: <#T##Resource#>, name: <#T##String#>, kind: <#T##SpanKind#>, timestamp: <#T##Timestamp#>, attributes: <#T##[String : AttributeValue]?#>, timedEvents: <#T##[TimedEvent]?#>, links: <#T##[Link]#>, status: <#T##Status?#>, endTimestamp: <#T##Timestamp#>)
//        return result
//    }
}
