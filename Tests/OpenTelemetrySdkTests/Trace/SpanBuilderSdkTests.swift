//
//  SpanBuilderSdkTest.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 07/11/2019.
//

import OpenTelemetryApi
@testable import OpenTelemetrySdk
import XCTest

class SpanBuilderSdkTest: XCTestCase {
    let spanName = "span_name"
    let sampledSpanContext = SpanContext.create(traceId: TraceId(idHi: 1000, idLo: 1000),
                                                spanId: SpanId(id: 3000),
                                                traceFlags: TraceFlags().settingIsSampled(true),
                                                tracestate: Tracestate())
    var tracerSdkFactory = TracerSdkFactory()
    var tracerSdk: Tracer!

    override func setUp() {
        tracerSdk = tracerSdkFactory.get(instrumentationName: "SpanBuilderSdkTest")
    }

    func testAddLink() {
        // Verify methods do not crash.
        let spanBuilder = tracerSdk.spanBuilder(spanName: spanName)
        spanBuilder.addLink(SpanData.Link(context: DefaultSpan().context))
        spanBuilder.addLink(spanContext: DefaultSpan().context)
        spanBuilder.addLink(spanContext: DefaultSpan().context, attributes: [String: AttributeValue]())
        let span = spanBuilder.startSpan() as! RecordEventsReadableSpan
        XCTAssertEqual(span.links.count, 3)
        span.end()
    }

    func testTruncateLink() {
        // TODO: review this test and functionality, needs dropping containers
//        let maxNumberOfLinks = 8
//        let traceConfig = tracerSdkFactory.getActiveTraceConfig().settingMaxNumberOfLinks(maxNumberOfLinks)
//        tracerSdkFactory.updateActiveTraceConfig(traceConfig)
//        // Verify methods do not crash.
//        let spanBuilder = tracerSdk.spanBuilder(spanName: spanName)
//        for _ in 0 ..< 2 * maxNumberOfLinks {
//            spanBuilder.addLink(spanContext:sampledSpanContext)
//        }
//        let span = spanBuilder.startSpan() as! RecordEventsReadableSpan
//        XCTAssertEqual(span.getDroppedLinksCount(), 3)
//        XCTAssertEqual(span.links.count, maxNumberOfLinks)
//        for i in 0 ..< maxNumberOfLinks {
//            XCTAssert(span.links[i] == SpanData.Link(context: sampledSpanContext))
//        }
//        span.end()
//        tracerSdkFactory.updateActiveTraceConfig(TraceConfig())
    }

    func testRecordEvents_default() {
        let span = tracerSdk.spanBuilder(spanName: spanName).startSpan() as! RecordEventsReadableSpan
        XCTAssertTrue(span.isRecordingEvents)
        span.end()
    }

    func testKind_default() {
        let span = tracerSdk.spanBuilder(spanName: spanName).startSpan() as! RecordEventsReadableSpan
        XCTAssertEqual(span.kind, SpanKind.internal)
        span.end()
    }

    func testKind() {
        let span = tracerSdk.spanBuilder(spanName: spanName).setSpanKind(spanKind: .consumer).startSpan() as! RecordEventsReadableSpan
        XCTAssertEqual(span.kind, SpanKind.consumer)
    }

    func testSampler() {
        let span = TestUtils.startSpanWithSampler(tracerSdkFactory: tracerSdkFactory,
                                                  tracer: tracerSdk, spanName: spanName,
            sampler: Samplers.alwaysOff).startSpan()
        XCTAssertFalse(span.context.traceFlags.sampled)
        span.end()
    }

    func testSampler_decisionAttributes() {
        class TestSampler: Sampler {

            var decision: Decision
            func shouldSample(parentContext: SpanContext?,
                              traceId: TraceId,
                              spanId: SpanId,
                              name: String,
                              parentLinks: [Link]) -> Decision {
                return decision
            }
            var description: String { return "TestSampler" }
            init(decision: Decision) { self.decision = decision }
        }

        class TestDecision: Decision {
            var isSampled: Bool {
                return true
            }
            var attributes: [String : AttributeValue] {
                return ["sampler-attribute": AttributeValue.string("bar")]
            }
        }

        let decision = TestDecision()
        let sampler = TestSampler(decision: decision)
        let span = TestUtils.startSpanWithSampler(tracerSdkFactory: tracerSdkFactory,
                                                  tracer: tracerSdk,
                                                  spanName:spanName,
                                                  sampler:sampler).startSpan() as! RecordEventsReadableSpan
        XCTAssertTrue(span.context.traceFlags.sampled)
        XCTAssertTrue(span.attributes.keys.contains("sampler-attribute"))
        span.end()
    }

    func testSampledViaParentLinks() {
        let span = TestUtils.startSpanWithSampler(tracerSdkFactory: tracerSdkFactory,
                                                  tracer: tracerSdk, spanName:spanName,
                                                  sampler:Samplers.probability(probability: 0.0))
            .addLink(spanContext: sampledSpanContext)
            .startSpan()
        XCTAssertTrue(span.context.traceFlags.sampled)
        span.end()
    }

    func testNoParent() {
        let parent = tracerSdk.spanBuilder(spanName: spanName).startSpan()
        var scope = tracerSdk.withSpan(parent)
        let span = tracerSdk.spanBuilder(spanName: spanName).setNoParent().startSpan()
        XCTAssertNotEqual(span.context.traceId, parent.context.traceId)
        let spanNoParent = tracerSdk.spanBuilder(spanName: spanName).setNoParent().setParent(parent).setNoParent().startSpan()
        XCTAssertNotEqual(span.context.traceId, parent.context.traceId)
        spanNoParent.end()
        span.end()
        scope.close()
        parent.end()
    }

    func testNoParent_override() {
        let parent = tracerSdk.spanBuilder(spanName: spanName).startSpan()
        let span = tracerSdk.spanBuilder(spanName: spanName).setNoParent().setParent(parent).startSpan() as! RecordEventsReadableSpan
        XCTAssertEqual(span.context.traceId, parent.context.traceId)
        XCTAssertEqual(span.parentSpanId, parent.context.spanId)
        let span2 = tracerSdk.spanBuilder(spanName: spanName).setNoParent().setParent(parent.context).startSpan()
        XCTAssertEqual(span2.context.traceId, parent.context.traceId)
        span2.end()
        span.end()
        parent.end()
    }

    func testOverrideNoParent_remoteParent() {
        let parent = tracerSdk.spanBuilder(spanName: spanName).startSpan()
        let span = tracerSdk.spanBuilder(spanName: spanName).setNoParent().setParent(parent.context).startSpan() as! RecordEventsReadableSpan
        XCTAssertEqual(span.context.traceId, parent.context.traceId)
        XCTAssertEqual(span.parentSpanId, parent.context.spanId)
        span.end()
        parent.end()
    }

    func testParentCurrentSpan() {
        let parent = tracerSdk.spanBuilder(spanName: spanName).startSpan()
        var scope = tracerSdk.withSpan(parent)
        let span = tracerSdk.spanBuilder(spanName: spanName).startSpan() as! RecordEventsReadableSpan
        XCTAssertEqual(span.context.traceId, parent.context.traceId)
        XCTAssertEqual(span.parentSpanId, parent.context.spanId)
        span.end()
        scope.close()
        parent.end()
    }

    func testParent_invalidContext() {
        let parent = DefaultSpan()
        let span = tracerSdk.spanBuilder(spanName: spanName).setParent(parent.context).startSpan() as! RecordEventsReadableSpan
        XCTAssertNotEqual(span.context.traceId, parent.context.traceId)
        XCTAssertNil(span.parentSpanId)
        span.end()
    }

    func testParent_timestampConverter() {
        let parent = tracerSdk.spanBuilder(spanName: spanName).startSpan()
        let span = tracerSdk.spanBuilder(spanName: spanName).setParent(parent).startSpan() as! RecordEventsReadableSpan
        XCTAssert(span.clock == (parent as! RecordEventsReadableSpan).clock)
        parent.end()
    }

    func testParentCurrentSpan_timestampConverter() {
        let parent = tracerSdk.spanBuilder(spanName: spanName).startSpan()
        var scope = tracerSdk.withSpan(parent)
        let span = tracerSdk.spanBuilder(spanName: spanName).startSpan() as! RecordEventsReadableSpan
        XCTAssert(span.clock == (parent as! RecordEventsReadableSpan).clock)
        scope.close()
        parent.end()
    }
}
