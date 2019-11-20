//
//  SpanBuilderTests.swift
//
//  Created by Ignacio Bonafonte on 23/10/2019.
//

@testable import OpenTelemetryApi
import XCTest

class SpanBuilderTests: XCTestCase {
    class TestLink: Link {
        var context: SpanContext {
            return DefaultSpan.random().context
        }
        var attributes: [String: AttributeValue] {
            return [String: AttributeValue]()
        }
    }

    let tracer = DefaultTracer.instance


    func testDoNotCrash_NoopImplementation() {
        let spanBuilder = tracer.spanBuilder(spanName: "MySpanName")
        spanBuilder.setSpanKind(spanKind: .server)
        spanBuilder.setParent(DefaultSpan.random())
        spanBuilder.setParent(DefaultSpan.random().context)
        spanBuilder.setNoParent()
        spanBuilder.addLink(spanContext: DefaultSpan.random().context)
        spanBuilder.addLink(spanContext: DefaultSpan.random().context, attributes: [String: AttributeValue]())
        spanBuilder.addLink(spanContext: DefaultSpan.random().context, attributes: [String: AttributeValue]())
        spanBuilder.addLink(TestLink())
        spanBuilder.setStartTimestamp(startTimestamp: 12345)
        XCTAssert(spanBuilder.startSpan() is DefaultSpan)
    }
}
