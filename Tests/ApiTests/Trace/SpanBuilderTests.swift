//
//  SpanBuilderTests.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 23/10/2019.
//

@testable import Api
import XCTest

class SpanBuilderTests: XCTestCase {
    let tracer = DefaultTracer.instance

    func testDoNotCrash_NoopImplementation() {
        let spanBuilder = tracer.spanBuilder(spanName: "MySpanName")
        spanBuilder.setSampler(sampler: Samplers.alwaysSample)
        spanBuilder.setSpanKind(spanKind: .server)
        spanBuilder.setParent(DefaultSpan.random())
        spanBuilder.setParent(DefaultSpan.random().context)
        spanBuilder.setNoParent()
        spanBuilder.setStartTimestamp(startTimestamp: Timestamp(fromMillis: 1))
        XCTAssert(spanBuilder.startSpan() is DefaultSpan)
    }
}
