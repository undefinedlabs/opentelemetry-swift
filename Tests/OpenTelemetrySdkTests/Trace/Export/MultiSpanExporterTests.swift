//
//  MultiSpanExporterTests.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 08/11/2019.
//

@testable import OpenTelemetrySdk
import XCTest

class MultiSpanExporterTests: XCTestCase {
    let spanExporter1 = SpanExporterMock()
    let spanExporter2 = SpanExporterMock()
    let spanList = [TestUtils.makeBasicSpan()]

    func testEmpty() {
        let multiSpanExporter = MultiSpanExporter(spanExporters: [SpanExporter]())

        _ = multiSpanExporter.export(spans: spanList)
        multiSpanExporter.shutdown()
    }

    func testOneSpanExporter() {
        let multiSpanExporter = MultiSpanExporter(spanExporters: [spanExporter1])
        spanExporter1.returnValue = .success
        XCTAssertEqual(multiSpanExporter.export(spans: spanList), SpanExporterResultCode.success)
        XCTAssertEqual(spanExporter1.exportCalledTimes, 1)
        multiSpanExporter.shutdown()
        XCTAssertEqual(spanExporter1.shutdownCalledTimes, 1)
    }

    func testTwoSpanExporter() {
        let multiSpanExporter = MultiSpanExporter(spanExporters: [spanExporter1, spanExporter2])
        spanExporter1.returnValue = .success
        spanExporter2.returnValue = .success
        XCTAssertEqual(multiSpanExporter.export(spans: spanList), SpanExporterResultCode.success)
        XCTAssertEqual(spanExporter1.exportCalledTimes, 1)
        XCTAssertEqual(spanExporter2.exportCalledTimes, 1)
        multiSpanExporter.shutdown()
        XCTAssertEqual(spanExporter1.shutdownCalledTimes, 1)
        XCTAssertEqual(spanExporter2.shutdownCalledTimes, 1)
    }

    func testTwoSpanExporter_OneReturnNoneRetryable() {
        let multiSpanExporter = MultiSpanExporter(spanExporters: [spanExporter1, spanExporter2])
        spanExporter1.returnValue = .success
        spanExporter1.returnValue = .failedNotRetryable
        XCTAssertEqual(multiSpanExporter.export(spans: spanList), SpanExporterResultCode.failedNotRetryable)
        XCTAssertEqual(spanExporter1.exportCalledTimes, 1)
        XCTAssertEqual(spanExporter2.exportCalledTimes, 1)
    }

    func testTwoSpanExporter_OneReturnRetryable() {
        let multiSpanExporter = MultiSpanExporter(spanExporters: [spanExporter1, spanExporter2])
        spanExporter1.returnValue = .success
        spanExporter1.returnValue = .failedRetryable
        XCTAssertEqual(multiSpanExporter.export(spans: spanList), SpanExporterResultCode.failedRetryable)
        XCTAssertEqual(spanExporter1.exportCalledTimes, 1)
        XCTAssertEqual(spanExporter2.exportCalledTimes, 1)
    }
}
