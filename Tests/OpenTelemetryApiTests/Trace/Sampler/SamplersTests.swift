//
//  SamplersTests.swift
//  OpenTelemetrySwift iOSTests
//
//  Created by Ignacio Bonafonte on 04/11/2019.
//

@testable import OpenTelemetryApi
import XCTest

class SamplersTests: XCTestCase {
    let traceId = TraceId.random()
    let parentSpanId = SpanId.random()
    let spanId = SpanId.random()
    let tracestate = Tracestate()
    var sampledSpanContext: SpanContext!
    var notSampledSpanContext: SpanContext!

    override func setUp() {
        sampledSpanContext = SpanContext(traceId: traceId, spanId: parentSpanId, traceFlags: TraceFlags().settingIsSampled(true), tracestate: tracestate)
        notSampledSpanContext = SpanContext(traceId: traceId, spanId: parentSpanId, traceFlags: TraceFlags(), tracestate: tracestate)
    }

    func testAlwaysSampleSampler_AlwaysReturnTrue() {
        // Sampled parent.
        XCTAssertTrue(Samplers.alwaysSample.shouldSample(parentContext: sampledSpanContext, hasRemoteParent: false, traceId: traceId, spanId: spanId, name: "another name", parentLinks: [Link]()).isSampled)
        // Not sampled parent.
        XCTAssertTrue(Samplers.alwaysSample.shouldSample(parentContext: notSampledSpanContext, hasRemoteParent: false, traceId: traceId, spanId: spanId, name: "another name", parentLinks: [Link]()).isSampled)
    }

    func testAlwaysSampleSampler_ToString() {
        XCTAssertEqual(Samplers.alwaysSample.description, "AlwaysSampleSampler")
    }

    func testNeverSampleSampler_AlwaysReturnFalse() {
        // Sampled parent.
        XCTAssertFalse(Samplers.neverSample.shouldSample(parentContext: sampledSpanContext, hasRemoteParent: false, traceId: traceId, spanId: spanId, name: "another name", parentLinks: [Link]()).isSampled)
        // Not sampled parent.
        XCTAssertFalse(Samplers.neverSample.shouldSample(parentContext: notSampledSpanContext, hasRemoteParent: false, traceId: traceId, spanId: spanId, name: "another name", parentLinks: [Link]()).isSampled)
    }

    func testNeverSampleSampler_ToString() {
        XCTAssertEqual(Samplers.neverSample.description, "NeverSampleSampler")
    }
}
