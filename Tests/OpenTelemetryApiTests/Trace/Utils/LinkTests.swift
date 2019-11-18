//
//  LinksTests.swift
//  OpenTelemetrySwift iOSTests
//
//  Created by Ignacio Bonafonte on 04/11/2019.
//

@testable import OpenTelemetryApi
import XCTest

class LinksTests: XCTestCase {
    var attributesMap = [String: AttributeValue]()
    let tracestate = Tracestate()
    var spanContext: SpanContext!

    override func setUp() {
        spanContext = SpanContext(traceId: TraceId.random(), spanId: SpanId.random(), traceFlags: TraceFlags(), tracestate: tracestate)
        attributesMap["MyAttributeKey0"] = AttributeValue.string("MyStringAttribute")
        attributesMap["MyAttributeKey1"] = AttributeValue.int(10)
        attributesMap["MyAttributeKey2"] = AttributeValue.bool(true)
    }

    func testCreate() {
        let link = SimpleLink(context: spanContext, attributes: attributesMap)
        XCTAssertEqual(link.context, spanContext)
        XCTAssertEqual(link.attributes, attributesMap)
    }

    func testCreate_NoAttributes() {
        let link = SimpleLink(context: spanContext)
        XCTAssertEqual(link.context, spanContext)
        XCTAssertEqual(link.attributes.count, 0)
    }

    func testLink_EqualsAndHashCode() {
        XCTAssertEqual( SimpleLink(context: spanContext),  SimpleLink(context: spanContext))
        XCTAssertNotEqual( SimpleLink(context: spanContext),  SimpleLink(context: spanContext, attributes: attributesMap))
        XCTAssertEqual( SimpleLink(context: spanContext, attributes: attributesMap),  SimpleLink(context: spanContext, attributes: attributesMap))
    }

    func testLink_ToString() {
        let link = SimpleLink(context: spanContext, attributes: attributesMap)
        XCTAssert(link.description.contains(spanContext.traceId.description))
        XCTAssert(link.description.contains(spanContext.spanId.description))
        XCTAssert(link.description.contains(attributesMap.description))
    }
}
