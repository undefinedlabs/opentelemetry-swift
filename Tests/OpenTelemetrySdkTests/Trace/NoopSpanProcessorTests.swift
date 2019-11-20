//
//  NoopSpanProcessorTest.swift
//
//  Created by Ignacio Bonafonte on 06/11/2019.
//
@testable import OpenTelemetrySdk
import XCTest

class NoopSpanProcessorTest: XCTestCase {
    let readableSpan = ReadableSpanMock()

    func testNoCrash() {
        let noopSpanProcessor = NoopSpanProcessor()
        noopSpanProcessor.onStart(span: readableSpan)
        noopSpanProcessor.onEnd(span: readableSpan)
        noopSpanProcessor.shutdown()
    }
}
