//
//  InMemorySpanExporterTests.swift
//  OpenTelemetrySwift iOSTests
//
//  Created by Ignacio Bonafonte on 08/11/2019.
//
@testable import OpenTelemetrySdk
import XCTest

class InMemorySpanExporterTests: XCTestCase {
    var tracer = TracerSdk()
    let exporter = InMemorySpanExporter()

    override func setUp() {
        tracer.addSpanProcessor(spanProcessor: SimpleSpanProcessor(spanExporter: exporter))
    }

    func testGetFinishedSpanItems() {
        tracer.spanBuilder(spanName: "one").startSpan().end()
        tracer.spanBuilder(spanName: "two").startSpan().end()
        tracer.spanBuilder(spanName: "three").startSpan().end()

        let spanItems = exporter.finishedSpanItems
        XCTAssertEqual(spanItems.count, 3)
        XCTAssertEqual(spanItems[0].name, "one")
        XCTAssertEqual(spanItems[1].name, "two")
        XCTAssertEqual(spanItems[2].name, "three")
    }

    func testReset() {
        tracer.spanBuilder(spanName: "one").startSpan().end()
        tracer.spanBuilder(spanName: "two").startSpan().end()
        tracer.spanBuilder(spanName: "three").startSpan().end()
        let spanItems = exporter.finishedSpanItems
        XCTAssertEqual(spanItems.count, 3)
        // Reset then expect no items in memory.
        exporter.reset()
        XCTAssertEqual(exporter.finishedSpanItems.count, 0)
    }

    func testShutdown() {
        tracer.spanBuilder(spanName: "one").startSpan().end()
        tracer.spanBuilder(spanName: "two").startSpan().end()
        tracer.spanBuilder(spanName: "three").startSpan().end()
        let spanItems = exporter.finishedSpanItems
        XCTAssertEqual(spanItems.count, 3)
        // Shutdown then expect no items in memory.
        exporter.shutdown()
        XCTAssertEqual(exporter.finishedSpanItems.count, 0)
        // Cannot add new elements after the shutdown.
        tracer.spanBuilder(spanName: "one").startSpan().end()
        XCTAssertEqual(exporter.finishedSpanItems.count, 0)
    }

    func testExport_ReturnCode() {
        XCTAssertEqual(exporter.export(spans: [TestUtils.makeBasicSpan()]), SpanExporterResultCode.success)
        exporter.shutdown()
        // After shutdown no more export.
        XCTAssertEqual(exporter.export(spans: [TestUtils.makeBasicSpan()]), SpanExporterResultCode.failedNotRetryable)
        exporter.reset()
        // Reset does not do anything if already shutdown.
        XCTAssertEqual(exporter.export(spans: [TestUtils.makeBasicSpan()]), SpanExporterResultCode.failedNotRetryable)
    }
}
