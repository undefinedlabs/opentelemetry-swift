//
//  MultiSpanProcessorTest.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 06/11/2019.
//
@testable import OpenTelemetrySwift
import XCTest

class MultiSpanProcessorTest: XCTestCase {
    let spanProcessor1 = SpanProcessorMock()
    let spanProcessor2 = SpanProcessorMock()
    let readableSpan = ReadableSpanMock()

    func testEmpty() {
        let multiSpanProcessor = MultiSpanProcessor(spanProcessors: [SpanProcessor]())
        multiSpanProcessor.onStart(span: readableSpan)
        multiSpanProcessor.onEnd(span: readableSpan)
        multiSpanProcessor.shutdown()
    }

    func testOneSpanProcessor() {
        let multiSpanProcessor = MultiSpanProcessor(spanProcessors: [spanProcessor1])
        multiSpanProcessor.onStart(span: readableSpan)
        XCTAssert(spanProcessor1.onStartCalledSpan === readableSpan)
        multiSpanProcessor.onEnd(span: readableSpan)
        XCTAssert(spanProcessor1.onEndCalledSpan === readableSpan)
        multiSpanProcessor.shutdown()
        XCTAssertTrue(spanProcessor1.shutdownCalled)
    }

    func testTwoSpanProcessor() {
        let multiSpanProcessor = MultiSpanProcessor(spanProcessors: [spanProcessor1, spanProcessor2])

        multiSpanProcessor.onStart(span: readableSpan)
        XCTAssert(spanProcessor1.onStartCalledSpan === readableSpan)
        XCTAssert(spanProcessor2.onStartCalledSpan === readableSpan)

        multiSpanProcessor.onEnd(span: readableSpan)
        XCTAssert(spanProcessor1.onEndCalledSpan === readableSpan)
        XCTAssert(spanProcessor2.onEndCalledSpan === readableSpan)

        multiSpanProcessor.shutdown()
        XCTAssertTrue(spanProcessor1.shutdownCalled)
        XCTAssertTrue(spanProcessor2.shutdownCalled)
    }
}
