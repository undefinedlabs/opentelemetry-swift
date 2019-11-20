//
//  TestUtils.swift
//
//  Created by Ignacio Bonafonte on 07/11/2019.
//

import Foundation
import OpenTelemetryApi
@testable import OpenTelemetrySdk

struct TestUtils {
    static func generateRandomAttributes() -> [String: AttributeValue] {
        var result = [String: AttributeValue]()
        let name = UUID().uuidString
        let attribute = AttributeValue.string(UUID().uuidString)
        result[name] = attribute
        return result
    }

    static func makeBasicSpan() -> SpanData {
        return SpanData(traceId: TraceId(), spanId: SpanId(), traceFlags: TraceFlags(), tracestate: Tracestate(), resource: Resource(), instrumentationLibraryInfo: InstrumentationLibraryInfo(), name: "spanName", kind: .server, startEpochNanos: 100000000000 + 100, endEpochNanos: 200000000000 + 200, hasRemoteParent: false)
    }

    static func startSpanWithSampler(tracerSdkFactory: TracerSdkFactory, tracer: Tracer, spanName: String, sampler: Sampler) -> SpanBuilder {
        let originalConfig = tracerSdkFactory.getActiveTraceConfig()
        tracerSdkFactory.updateActiveTraceConfig(originalConfig.settingSampler(sampler))
        defer { tracerSdkFactory.updateActiveTraceConfig(originalConfig) }
        return tracer.spanBuilder(spanName: spanName)
    }
}
