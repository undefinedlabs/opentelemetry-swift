//
//  DefaultTracerTests.swift
//
//
//  Created by Ignacio Bonafonte on 22/10/2019.
//

import Foundation

@testable import Api
import XCTest

final class DefaultTracerTests: XCTestCase {
    let defaultTracer = DefaultTracer.instance
    let spanName = "MySpanName"
    let firstBytes: [UInt8] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, UInt8(ascii: "a")]

    var spanContext: SpanContext!

    override func setUp() {
        spanContext = SpanContext(traceId: TraceId(fromBytes: firstBytes), spanId: SpanId(fromBytes: firstBytes, withOffset: 8), traceFlags: TraceFlags(), tracestate: Tracestate())
    }

    func testDefaultGetCurrentSpan() {
        XCTAssert(defaultTracer.currentSpan is DefaultSpan?)
    }

    func testGetCurrentSpan_WithSpan() {
        XCTAssert(defaultTracer.currentSpan == nil)
        var ws = defaultTracer.withSpan(DefaultSpan.random())
        XCTAssert(defaultTracer.currentSpan != nil)
        XCTAssert(defaultTracer.currentSpan is DefaultSpan)
        ws.close()
        XCTAssert(defaultTracer.currentSpan == nil)
    }

    func testDefaultSpanBuilderWithName() {
        XCTAssert(defaultTracer.spanBuilder(spanName: spanName).startSpan() is DefaultSpan)
    }

    func testDefaultHttpTextFormat() {
        XCTAssert(defaultTracer.textFormat is HttpTraceContextFormat)
    }

    func testTestInProcessContext() {
        let span = defaultTracer.spanBuilder(spanName: spanName).startSpan()
        var scope = defaultTracer.withSpan(span)
        XCTAssert(defaultTracer.currentSpan === span)

        let secondSpan = defaultTracer.spanBuilder(spanName: spanName).startSpan()
        var secondScope = defaultTracer.withSpan(secondSpan)

        XCTAssert(defaultTracer.currentSpan === secondSpan)

        secondScope.close()
        XCTAssert(defaultTracer.currentSpan === span)

        scope.close()
        XCTAssert(defaultTracer.currentSpan == nil)
    }

    func testTestSpanContextPropagationExplicitParent() {
        let span = defaultTracer.spanBuilder(spanName: spanName).setParent(spanContext).startSpan()
        XCTAssert(span.context === spanContext)
    }

    func testTestSpanContextPropagation() {
        let parent = DefaultSpan(context: spanContext)

        let span = defaultTracer.spanBuilder(spanName: spanName).setParent(parent).startSpan()
        XCTAssert(span.context === spanContext)
    }

    func testTestSpanContextPropagationCurrentSpan() {
        let parent = DefaultSpan(context: spanContext)
        var scope = defaultTracer.withSpan(parent)
        let span = defaultTracer.spanBuilder(spanName: spanName).startSpan()
        XCTAssert(span.context === spanContext)
        scope.close()
    }
}
