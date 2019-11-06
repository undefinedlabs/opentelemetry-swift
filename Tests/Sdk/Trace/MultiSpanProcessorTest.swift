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

//    func testOneSpanProcessor() {
//        let multiSpanProcessor = MultiSpanProcessor(spanProcessors: [spanProcessor1])
//        multiSpanProcessor.onStart(span: readableSpan)
//        XCTAssert(spanProcessor1.onStartCalledSpan == readableSpan as? ReadableSpan)

//      multiSpanProcessor.onEnd(readableSpan);
//      verify(spanProcessor1).onEnd(same(readableSpan));
//
//      multiSpanProcessor.shutdown();
//      verify(spanProcessor1).shutdown();
//    }

//    func testTwoSpanProcessor() {
//      SpanProcessor multiSpanProcessor =
//          MultiSpanProcessor.create(Arrays.asList(spanProcessor1, spanProcessor2));
//      multiSpanProcessor.onStart(readableSpan);
//      verify(spanProcessor1).onStart(same(readableSpan));
//      verify(spanProcessor2).onStart(same(readableSpan));
//
//      multiSpanProcessor.onEnd(readableSpan);
//      verify(spanProcessor1).onEnd(same(readableSpan));
//      verify(spanProcessor2).onEnd(same(readableSpan));
//
//      multiSpanProcessor.shutdown();
//      verify(spanProcessor1).shutdown();
//      verify(spanProcessor2).shutdown();
//    }
}
