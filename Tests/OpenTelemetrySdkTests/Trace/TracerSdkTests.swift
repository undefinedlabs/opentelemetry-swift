//
import OpenTelemetryApi
//  TracerSdkTests.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 07/11/2019.
//
@testable import OpenTelemetrySdk
import XCTest

class TracerSdkTests: XCTestCase {
    let spanName = "span_name"
    let instrumentationLibraryName = "TracerSdkTest"
    let instrumentationLibraryVersion = "semver:0.2.0"
    var instrumentationLibraryInfo: InstrumentationLibraryInfo!
    var span = SpanMock()
    var spanProcessor = SpanProcessorMock()
    var tracerSdkFactory = TracerSdkFactory()
    var tracer: TracerSdk!

    override func setUp() {
        instrumentationLibraryInfo = InstrumentationLibraryInfo(name: instrumentationLibraryName, version: instrumentationLibraryVersion)
        tracer = (tracerSdkFactory.get(instrumentationName: instrumentationLibraryName, instrumentationVersion: instrumentationLibraryVersion) as! TracerSdk)
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
//        let origContext = ContextUtils.withSpan(span)
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

    func testGetInstrumentationLibraryInfo() {
        XCTAssertEqual(tracer.instrumentationLibraryInfo, instrumentationLibraryInfo)
    }

    func testPropagatesInstrumentationLibraryInfoToSpan() {
        let readableSpan = tracer.spanBuilder(spanName: "spanName").startSpan() as! ReadableSpan
        XCTAssertEqual(readableSpan.instrumentationLibraryInfo, instrumentationLibraryInfo)
    }
}
