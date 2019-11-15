//
//  EventsTests.swift
//  OpenTelemetrySwift iOSTests
//
//  Created by Ignacio Bonafonte on 04/11/2019.
//

@testable import Api
import XCTest

class EventsTests: XCTestCase {
    var attributesMap = [String: AttributeValue]()

    override func setUp() {
        attributesMap["MyAttributeKey0"] = AttributeValue.string("MyStringAttribute")
        attributesMap["MyAttributeKey1"] = AttributeValue.int(10)
        attributesMap["MyAttributeKey2"] = AttributeValue.bool(true)
    }

    func textCreate() {
        let event = SimpleEvent(name: "test", attributes: attributesMap)
        XCTAssertEqual(event.name, "test")
        XCTAssertEqual(event.attributes, attributesMap)
    }

    func textCreate_NoAttributes() {
        let event = SimpleEvent(name: "test")
        XCTAssertEqual(event.name, "test")
        XCTAssertEqual(event.attributes.count, 0)
    }

    func testLink_EqualsAndHashCode() {
        XCTAssertEqual(SimpleEvent(name: "test"), SimpleEvent(name: "test"))
        XCTAssertNotEqual(SimpleEvent(name: "test"), SimpleEvent(name: "test", attributes: attributesMap))
        XCTAssertEqual(SimpleEvent(name: "test", attributes: attributesMap), SimpleEvent(name: "test", attributes: attributesMap))
    }

    func testLink_ToString() {
        let event = SimpleEvent(name: "test", attributes: attributesMap)
        XCTAssert(event.description.contains("test"))
        XCTAssert(event.description.contains(attributesMap.description))
    }
}
