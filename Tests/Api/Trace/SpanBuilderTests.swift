//
//  SpanBuilderTests.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 23/10/2019.
//

@testable import OpenTelemetrySwift
import XCTest

class SpanBuilderTests: XCTestCase {
    let tracer = DefaultTracer()

    func testDoNotCrash_NoopImplementation() {
        let spanBuilder = tracer.spanBuilder(spanName: "MySpanName")
        spanBuilder.setSampler(sampler: Samplers.AlwaysSample)
        spanBuilder.setSpanKind(spanKind: .server)
        spanBuilder.setParent(parent: DefaultSpan.createRandom())
        spanBuilder.setParent(parent: DefaultSpan.createRandom().context)
        spanBuilder.setNoParent()
        spanBuilder.setStartTimestamp(startTimestamp: Timestamp(fromMillis: 1))
        XCTAssert(spanBuilder.startSpan() is DefaultSpan)
    }
}
