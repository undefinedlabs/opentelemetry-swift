//
//  SpanBuilderSdkTest.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 07/11/2019.
//

@testable import OpenTelemetrySdk
import OpenTelemetryApi
import XCTest

class SpanBuilderSdkTest: XCTestCase {
    let spanName = "span_name"
    let sampledSpanContext = SpanContext(traceId: TraceId(idHi: 1000, idLo: 1000), spanId: SpanId(id: 3000), traceFlags: TraceFlags().settingIsSampled(true), tracestate: Tracestate())
    var tracer = TracerSdk()

    func testAddLink() {
        // Verify methods do not crash.
        let spanBuilder = tracer.spanBuilder(spanName: spanName)
        spanBuilder.addLink(SimpleLink(context: DefaultSpan().context))
        spanBuilder.addLink(spanContext: DefaultSpan().context)
        spanBuilder.addLink(spanContext: DefaultSpan().context, attributes: [String: AttributeValue]())
        let span = spanBuilder.startSpan() as! RecordEventsReadableSpan
        XCTAssertEqual(span.links.count, 3)
        span.end()
    }

    func testTruncateLink() {
        // TODO: revew this test and functionality
//        let maxNumberOfLinks = 8
//        let link = SimpleLink(context: DefaultSpan().context)
//        let traceConfig = TraceConfig().settingMaxNumberOfLinks(maxNumberOfLinks)
//        tracer.activeTraceConfig = traceConfig
//        // Verify methods do not crash.
//        let spanBuilder = tracer.spanBuilder(spanName: spanName)
//        for _ in 0 ..< 2 * maxNumberOfLinks {
//            spanBuilder.addLink(link: link)
//        }
//        let span = spanBuilder.startSpan() as! RecordEventsReadableSpan
//        XCTAssertEqual(span.getDroppedLinksCount(), 3)
//        XCTAssertEqual(span.links.count, maxNumberOfLinks)
//        for i in 0 ..< maxNumberOfLinks {
//            XCTAssert(span.links[i] == SimpleLink(context: span.context))
//        }
//        span.end()
//        tracer.activeTraceConfig = TraceConfig()
    }

    func testRecordEvents_default() {
        let span = tracer.spanBuilder(spanName: spanName).startSpan() as! RecordEventsReadableSpan
        XCTAssertTrue(span.isRecordingEvents)
        span.end()
    }

    func testRecordEvents_neverSample() {
        let span = tracer.spanBuilder(spanName: spanName).setSampler(sampler: Samplers.neverSample).startSpan() as! RecordEventsReadableSpan
        XCTAssertFalse(span.context.traceFlags.sampled)
        span.end()
    }

    func testKind_default() {
        let span = tracer.spanBuilder(spanName: spanName).startSpan() as! RecordEventsReadableSpan
        XCTAssertEqual(span.kind, SpanKind.internal)
        span.end()
    }

    func testKind() {
        let span = tracer.spanBuilder(spanName: spanName).setSpanKind(spanKind: .consumer).startSpan() as! RecordEventsReadableSpan
        XCTAssertEqual(span.kind, SpanKind.consumer)
    }

    func testSampler() {
        let span = tracer.spanBuilder(spanName: spanName).setSampler(sampler: Samplers.neverSample).startSpan()
        XCTAssertFalse(span.context.traceFlags.sampled)
        span.end()
    }

    func testSampler_decisionAttributes() {
        class TestSampler: Sampler {
            var decision: Decision
            func shouldSample(parentContext: SpanContext?, hasRemoteParent: Bool, traceId: TraceId, spanId: SpanId, name: String, parentLinks: [Link]) -> Decision {
                return decision
            }

            var description: String { return "TestSampler" }
            init(decision: Decision) { self.decision = decision }
        }
        let decision = Decision(isSampled: true, attributes: ["sampler-attribute": AttributeValue.string("bar")])
        let sampler = TestSampler(decision: decision)
        let span = tracer.spanBuilder(spanName: spanName).setSampler(sampler: sampler).startSpan() as! RecordEventsReadableSpan
        XCTAssertTrue(span.context.traceFlags.sampled)
        XCTAssertTrue(span.attributes.keys.contains("sampler-attribute"))
        span.end()
    }

    func testSampledViaParentLinks() {
        let span = tracer.spanBuilder(spanName: spanName).setSampler(sampler: ProbabilitySampler(probability: 0.0)).addLink(SimpleLink(context: sampledSpanContext)).startSpan()
        XCTAssertTrue(span.context.traceFlags.sampled)
        span.end()
    }

    func testNoParent() {
        let parent = tracer.spanBuilder(spanName: spanName).startSpan()
        var scope = tracer.withSpan(parent)
        let span = tracer.spanBuilder(spanName: spanName).setNoParent().startSpan()
        XCTAssertNotEqual(span.context.traceId, parent.context.traceId)
        let spanNoParent = tracer.spanBuilder(spanName: spanName).setNoParent().setParent(parent).setNoParent().startSpan()
        XCTAssertNotEqual(span.context.traceId, parent.context.traceId)
        spanNoParent.end()
        span.end()
        scope.close()
        parent.end()
    }

    func testNoParent_override() {
        let parent = tracer.spanBuilder(spanName: spanName).startSpan()
        let span = tracer.spanBuilder(spanName: spanName).setNoParent().setParent(parent).startSpan() as! RecordEventsReadableSpan
        XCTAssertEqual(span.context.traceId, parent.context.traceId)
        XCTAssertEqual(span.parentSpanId, parent.context.spanId)
        let span2 = tracer.spanBuilder(spanName: spanName).setNoParent().setParent(parent.context).startSpan()
        XCTAssertEqual(span2.context.traceId, parent.context.traceId)
        span2.end()
        span.end()
        parent.end()
    }

    func testOverrideNoParent_remoteParent() {
        let parent = tracer.spanBuilder(spanName: spanName).startSpan()
        let span = tracer.spanBuilder(spanName: spanName).setNoParent().setParent(parent.context).startSpan() as! RecordEventsReadableSpan
        XCTAssertEqual(span.context.traceId, parent.context.traceId)
        XCTAssertEqual(span.parentSpanId, parent.context.spanId)
        span.end()
        parent.end()
    }

    func testParentCurrentSpan() {
        let parent = tracer.spanBuilder(spanName: spanName).startSpan()
        var scope = tracer.withSpan(parent)
        let span = tracer.spanBuilder(spanName: spanName).startSpan() as! RecordEventsReadableSpan
        XCTAssertEqual(span.context.traceId, parent.context.traceId)
        XCTAssertEqual(span.parentSpanId, parent.context.spanId)
        span.end()
        scope.close()
        parent.end()
    }

    func testParent_invalidContext() {
        let parent = DefaultSpan()
        let span = tracer.spanBuilder(spanName: spanName).setParent(parent.context).startSpan() as! RecordEventsReadableSpan
        XCTAssertNotEqual(span.context.traceId, parent.context.traceId)
        XCTAssertNil(span.parentSpanId)
        span.end()
    }

    func testParent_timestampConverter() {
        let parent = tracer.spanBuilder(spanName: spanName).startSpan()
        let span = tracer.spanBuilder(spanName: spanName).setParent(parent).startSpan() as! RecordEventsReadableSpan
        XCTAssertEqual(span.timestampConverter, (parent as! RecordEventsReadableSpan).timestampConverter)
        parent.end()
    }

    func testParentCurrentSpan_timestampConverter() {
        let parent = tracer.spanBuilder(spanName: spanName).startSpan()
        var scope = tracer.withSpan(parent)
        let span = tracer.spanBuilder(spanName: spanName).startSpan() as! RecordEventsReadableSpan
        XCTAssertEqual(span.timestampConverter, (parent as! RecordEventsReadableSpan).timestampConverter)
        scope.close()
        parent.end()
    }
}
