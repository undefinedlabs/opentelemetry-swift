//
//  TracerSdkTests.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 07/11/2019.
//
@testable import OpenTelemetrySdk
import OpenTelemetryApi
import XCTest

class TracerSdkTests: XCTestCase {
    let spanName = "span_name"
    var span = SpanMock()
    var spanProcessor = SpanProcessorMock()
    var tracer = TracerSdk()

    override func setUp() {
        tracer.addSpanProcessor(spanProcessor: spanProcessor)
    }

    func testDefaultGetCurrentSpan() {
        XCTAssertNil(tracer.currentSpan)
    }

    func testDefaultSpanBuilder() {
        XCTAssertTrue(tracer.spanBuilder(spanName: spanName) is SpanBuilderSdk)
    }

    func testDefaultHttpTextFormat() {
        XCTAssertTrue(tracer.textFormat is HttpTraceContextFormat)
    }

    func testDefaultBinaryFormat() {
        XCTAssertTrue(tracer.binaryFormat is BinaryTraceContextFormat)
    }

    func testGetCurrentSpan() {
        XCTAssertNil(tracer.currentSpan)
        // Make sure context is detached even if test fails.
        // TODO: Check context bahaviour
//        let origContext = ContextUtils.with(span: span)
//        XCTAssertTrue(tracer.currentSpan === span)
//        XCTAssertTrue(tracer.currentSpan is DefaultSpan)
    }

    func testGetCurrentSpan_WithSpan() {
        // TODO: Review, only works in isolation
        XCTAssertNil(tracer.currentSpan)
        var ws = tracer.withSpan(span)
        XCTAssertTrue(tracer.currentSpan === span)
        ws.close()
        XCTAssertNil(tracer.currentSpan)
    }

    func testUpdateActiveTraceConfig() {
        XCTAssertEqual(tracer.activeTraceConfig, TraceConfig())
        let newConfig = TraceConfig().settingSampler(Samplers.neverSample)
        tracer.activeTraceConfig = newConfig
        XCTAssertEqual(tracer.activeTraceConfig, newConfig)
    }

    func testShutdown() {
        tracer.shutdown()
        XCTAssertEqual(spanProcessor.shutdownCalledTimes, 1)
        tracer.unsafeRestart()
    }

    func testShutdownTwice_OnlyFlushSpanProcessorOnce() {
        tracer.shutdown()
        XCTAssertEqual(spanProcessor.shutdownCalledTimes, 1)
        tracer.shutdown() // the second call will be ignored
        XCTAssertEqual(spanProcessor.shutdownCalledTimes, 1)
        tracer.unsafeRestart()
    }

    func testReturnNoopSpanAfterShutdown() {
        tracer.shutdown()
        let span = tracer.spanBuilder(spanName: spanName).setSampler(sampler: Samplers.alwaysSample).startSpan()
        XCTAssertTrue(span is DefaultSpan)
        span.end()
        tracer.unsafeRestart()
    }
}
