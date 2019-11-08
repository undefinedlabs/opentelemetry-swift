//
//  SimpleSpansProcessorTests.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 08/11/2019.
//
@testable import OpenTelemetrySwift
import XCTest

class SimpleSpansProcessorTests: XCTestCase {
    let maxScheduleDelayMillis = 500
    let spanName = "MySpanName"
    var readableSpan = ReadableSpanMock()
    var spanExporter = SpanExporterMock()
    let tracerSdk = TracerSdk()
    //   let waitingSpanExporter = WaitingSpanExporter();
    let sampledSpanContext = SpanContext(traceId: TraceId(), spanId: SpanId(), traceFlags: TraceFlags().settingIsSampled(true), tracestate: Tracestate())
    let notSampledSpanContext = SpanContext(traceId: TraceId(), spanId: SpanId(), traceFlags: TraceFlags(), tracestate: Tracestate())

    var simpleSampledSpansProcessor: SimpleSpanProcessor!

    override func setUp() {
        simpleSampledSpansProcessor = SimpleSpanProcessor(spanExporter: spanExporter)
    }

    func testOnStartSync() {
        simpleSampledSpansProcessor.onStart(span: readableSpan)
        XCTAssertTrue(spanExporter.exportCalledTimes == 0 && spanExporter.shutdownCalledTimes == 0)
    }

    func testOnEndSync_SampledSpan() {
        let spanData = TestUtils.makeBasicSpan()
        readableSpan.forcedReturnSpanContext = sampledSpanContext
        readableSpan.forcedReturnSpanData = spanData
        simpleSampledSpansProcessor.onEnd(span: readableSpan)
        XCTAssertEqual(spanExporter.exportCalledTimes, 1)
    }

    func testOnEndSync_NotSampledSpan() {
        readableSpan.forcedReturnSpanContext = notSampledSpanContext
        simpleSampledSpansProcessor.onEnd(span: readableSpan)
        XCTAssertTrue(spanExporter.exportCalledTimes == 0 && spanExporter.shutdownCalledTimes == 0)
    }

    func testOnEndSync_OnlySampled_NotSampledSpan() {
        readableSpan.forcedReturnSpanContext = notSampledSpanContext
        readableSpan.forcedReturnSpanData = TestUtils.makeBasicSpan()
        var simpleSpansProcessor = SimpleSpanProcessor(spanExporter: spanExporter).reportingOnlySampled(sampled: true)
        simpleSpansProcessor.onEnd(span: readableSpan)
        XCTAssertTrue(spanExporter.exportCalledTimes == 0 && spanExporter.shutdownCalledTimes == 0)
    }

    func testOnEndSync_OnlySampled_SampledSpan() {
        readableSpan.forcedReturnSpanContext = sampledSpanContext
        readableSpan.forcedReturnSpanData = TestUtils.makeBasicSpan()
        var simpleSpansProcessor = SimpleSpanProcessor(spanExporter: spanExporter).reportingOnlySampled(sampled: true)
        simpleSpansProcessor.onEnd(span: readableSpan)
        XCTAssertEqual(spanExporter.exportCalledTimes, 1)
    }

    func testTracerSdk_NotSampled_Span() {
//TODO: Needs BatchSpansProcessor
//        tracerSdk.addSpanProcessor(BatchSpansProcessor(waitingSpanExporter).setScheduleDelayMillis(maxScheduleDelayMillis))
//        tracerSdk.spanBuilder(spanName: spanName).setSampler(sampler: Samplers.neverSample).startSpan().end()
//        tracerSdk.spanBuilder(spanName: spanName).setSampler(sampler: Samplers.neverSample).startSpan().end()
//        let span = tracerSdk.spanBuilder(spanName: spanName).setSampler(sampler: Samplers.alwaysSample).startSpan()
//        span.end()
//
//        // Spans are recorded and exported in the same order as they are ended, we test that a non
//        // sampled span is not exported by creating and ending a sampled span after a non sampled span
//        // and checking that the first exported span is the sampled span (the non sampled did not get
//        // exported).
//        let exported = waitingSpanExporter.waitForExport(1)
//        // Need to check this because otherwise the variable span1 is unused, other option is to not
//        // have a span1 variable.
//        XCTAssertEqual(exported, (span as! ReadableSpan).toSpanData())
    }


    func testTracerSdk_NotSampled_RecordingEventsSpan() {
      // TODO(bdrutu): Fix this when Sampler return RECORD option.
      /*
      tracerSdk.addSpanProcessor(
          BatchSpansProcessor.newBuilder(waitingSpanExporter)
              .setScheduleDelayMillis(MAX_SCHEDULE_DELAY_MILLIS)
              .reportOnlySampled(false)
              .build());

      io.opentelemetry.trace.Span span =
          tracerSdk
              .spanBuilder("FOO")
              .setSampler(Samplers.neverSample())
              .startSpan();
      span.end();

      List<SpanData> exported = waitingSpanExporter.waitForExport(1);
      assertThat(exported).containsExactly(((ReadableSpan) span).toSpanData());
      */
    }

    func testOnEndSync_ExporterReturnError() {
      let spanData = TestUtils.makeBasicSpan();
      readableSpan.forcedReturnSpanContext = sampledSpanContext
      readableSpan.forcedReturnSpanData = spanData
        simpleSampledSpansProcessor.onEnd(span: readableSpan);
      // Try again, now will no longer return error.
        simpleSampledSpansProcessor.onEnd(span: readableSpan);
        XCTAssertEqual(spanExporter.exportCalledTimes, 2)
    }

    func testShutdown() {
      simpleSampledSpansProcessor.shutdown();
        XCTAssertEqual(spanExporter.shutdownCalledTimes, 1)
    }
}

