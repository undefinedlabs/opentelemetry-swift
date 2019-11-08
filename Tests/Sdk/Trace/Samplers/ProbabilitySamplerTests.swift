//
//  ProbabilitySamplerTest.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 07/11/2019.
//

@testable import OpenTelemetrySwift
import XCTest

class ProbabilitySamplerTest: XCTestCase {
    let spanName = "MySpanName"
    let numSamplesTries = 1000
    let traceId = TraceId.random()
    let parentSpanId = SpanId.random()
    let tracestate = Tracestate()
    var sampledSpanContext: SpanContext!
    var notSampledSpanContext: SpanContext!
    var sampledParentLink: SimpleLink!

    override func setUp() {
        sampledSpanContext = SpanContext(traceId: traceId, spanId: parentSpanId, traceFlags: TraceFlags().settingIsSampled(true), tracestate: tracestate)
        notSampledSpanContext = SpanContext(traceId: traceId, spanId: parentSpanId, traceFlags: TraceFlags(), tracestate: tracestate)
        sampledParentLink = SimpleLink(context: sampledSpanContext)
    }

    func testProbabilitySampler_AlwaysSample() {
        let sampler = ProbabilitySampler(probability: 1)
        XCTAssertEqual(sampler.idUpperBound, UInt.max)
    }

    func testProbabilitySampler_NeverSample() {
        let sampler = ProbabilitySampler(probability: 0)
        XCTAssertEqual(sampler.idUpperBound, UInt.min)
    }

    func testProbabilitySampler_outOfRangeHighProbability() {
        let sampler = ProbabilitySampler(probability: 1.01)
        XCTAssertEqual(sampler.idUpperBound, UInt.max)
    }

    func testProbabilitySampler_outOfRangeLowProbability() {
        let sampler = ProbabilitySampler(probability: -0.0001)
        XCTAssertEqual(sampler.idUpperBound, UInt.min)
    }

    func testProbabilitySampler_getDescription() {
        XCTAssertEqual(ProbabilitySampler(probability: 0.5).description, String(format: "ProbabilitySampler{%.6f}", 0.5))
    }

    func testProbabilitySampler_ToString() {
        XCTAssertTrue(ProbabilitySampler(probability: 0.5).description.contains("0.5"))
    }

    // Applies the given sampler to NUM_SAMPLE_TRIES random traceId/spanId pairs.
    private func assertSamplerSamplesWithProbability(sampler: Sampler, parent: SpanContext, parentLinks: [Link], probability: Double) {
        var count = 0 // Count of spans with sampling enabled
        for _ in 0 ..< numSamplesTries {
            if sampler.shouldSample(parentContext: parent, hasRemoteParent: false, traceId: TraceId.random(), spanId: SpanId.random(), name: spanName, parentLinks: parentLinks).isSampled {
                count += 1
            }
        }
        let proportionSampled = Double(count) / Double(numSamplesTries)
        // Allow for a large amount of slop (+/- 10%) in number of sampled traces, to avoid flakiness.
        XCTAssertTrue(proportionSampled < probability + 0.1 && proportionSampled > probability - 0.1)
    }

    func testProbabilitySampler_DifferentProbabilities_NotSampledParent() {
        let fiftyPercentSample = ProbabilitySampler(probability: 0.5)
        assertSamplerSamplesWithProbability(sampler: fiftyPercentSample, parent: notSampledSpanContext, parentLinks: [Link](), probability: 0.5)
        let twentyPercentSample = ProbabilitySampler(probability: 0.2)
        assertSamplerSamplesWithProbability(sampler: twentyPercentSample, parent: notSampledSpanContext, parentLinks: [Link](), probability: 0.2)
        let twoThirdsSample = ProbabilitySampler(probability: 2.0 / 3.0)
        assertSamplerSamplesWithProbability(sampler: twoThirdsSample, parent: notSampledSpanContext, parentLinks: [Link](), probability: 2.0 / 3.0)
    }

    func testProbabilitySampler_DifferentProbabilities_SampledParent() {
        let fiftyPercentSample = ProbabilitySampler(probability: 0.5)
        assertSamplerSamplesWithProbability(sampler: fiftyPercentSample, parent: sampledSpanContext, parentLinks: [Link](), probability: 1.0)
        let twentyPercentSample = ProbabilitySampler(probability: 0.2)
        assertSamplerSamplesWithProbability(sampler: twentyPercentSample, parent: sampledSpanContext, parentLinks: [Link](), probability: 1.0)
        let twoThirdsSample = ProbabilitySampler(probability: 2.0 / 3.0)
        assertSamplerSamplesWithProbability(sampler: twoThirdsSample, parent: sampledSpanContext, parentLinks: [Link](), probability: 1.0)
    }

    func testProbabilitySampler_DifferentProbabilities_SampledParentLink() {
        let fiftyPercentSample = ProbabilitySampler(probability: 0.5)
        assertSamplerSamplesWithProbability(sampler: fiftyPercentSample, parent: notSampledSpanContext, parentLinks: [sampledParentLink], probability: 1.0)
        let twentyPercentSample = ProbabilitySampler(probability: 0.2)
        assertSamplerSamplesWithProbability(sampler: twentyPercentSample, parent: notSampledSpanContext, parentLinks: [sampledParentLink], probability: 1.0)
        let twoThirdsSample = ProbabilitySampler(probability: 2.0 / 3.0)
        assertSamplerSamplesWithProbability(sampler: twoThirdsSample, parent: notSampledSpanContext, parentLinks: [sampledParentLink], probability: 1.0)
    }

    func testProbabilitySampler_SampleBasedOnTraceId() {
        let defaultProbability = ProbabilitySampler(probability: 0.0001)
        // This traceId will not be sampled by the ProbabilitySampler because the first 8 bytes as long
        // is not less than probability * Long.MAX_VALUE;
        let notSampledtraceId = TraceId(fromBytes: [0x8F, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0, 0, 0, 0, 0, 0, 0, 0])

        let decision1 = defaultProbability.shouldSample(parentContext: nil, hasRemoteParent: false, traceId: notSampledtraceId, spanId: SpanId.random(), name: spanName, parentLinks: [Link]())
        XCTAssertFalse(decision1.isSampled)
        XCTAssertEqual(decision1.attributes.count, 0)
        // This traceId will be sampled by the ProbabilitySampler because the first 8 bytes as long
        // is less than probability * Long.MAX_VALUE;
        let sampledtraceId = TraceId(fromBytes: [0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0, 0, 0, 0, 0, 0, 0, 0])
        let decision2 = defaultProbability.shouldSample(parentContext: nil, hasRemoteParent: false, traceId: sampledtraceId, spanId: SpanId.random(), name: spanName, parentLinks: [Link]())
        XCTAssertTrue(decision2.isSampled)
        XCTAssertEqual(decision2.attributes.count, 0)
    }
}
