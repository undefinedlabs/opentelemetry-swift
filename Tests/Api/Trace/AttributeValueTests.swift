//
//  AttributeValueTest.swift
//  OpenTelemetrySwift Tests
//
//  Created by Ignacio Bonafonte on 23/10/2019.
//

@testable import OpenTelemetrySwift
import XCTest

class AttributeValueTest: XCTestCase {
    func testAttributeValue_EqualsAndHashCode() {
        XCTAssertEqual(AttributeValue.string("MyStringAttributeValue"), AttributeValue.string("MyStringAttributeValue"))
        XCTAssertNotEqual(AttributeValue.string("MyStringAttributeValue"), AttributeValue.string("MyStringAttributeDiffValue"))
        XCTAssertNotEqual(AttributeValue.string("MyStringAttributeValue"), AttributeValue.bool(true))
        XCTAssertNotEqual(AttributeValue.string("MyStringAttributeValue"), AttributeValue.int(123456))
        XCTAssertNotEqual(AttributeValue.string("MyStringAttributeValue"), AttributeValue.double(1.23456))
        XCTAssertEqual(AttributeValue.bool(true), AttributeValue.bool(true))
        XCTAssertNotEqual(AttributeValue.bool(true), AttributeValue.bool(false))
        XCTAssertNotEqual(AttributeValue.bool(true), AttributeValue.int(123456))
        XCTAssertNotEqual(AttributeValue.bool(true), AttributeValue.double(1.23456))
        XCTAssertEqual(AttributeValue.int(123456), AttributeValue.int(123456))
        XCTAssertNotEqual(AttributeValue.int(123456), AttributeValue.int(1234567))
        XCTAssertNotEqual(AttributeValue.int(123456), AttributeValue.double(1.23456))
        XCTAssertEqual(AttributeValue.double(1.23456), AttributeValue.double(1.23456))
        XCTAssertNotEqual(AttributeValue.double(1.23456), AttributeValue.double(1.234567))
    }

    func testAttributeValue_Tostring() {
        var attribute = AttributeValue.string("MyStringAttributeValue")
        XCTAssert(attribute.description.contains("MyStringAttributeValue"))
        attribute = AttributeValue.bool(true)
        XCTAssert(attribute.description.contains("true"))
        attribute = AttributeValue.int(123456)
        XCTAssert(attribute.description.contains("123456"))
        attribute = AttributeValue.double(1.23456)
        XCTAssert(attribute.description.contains("1.23456"))
    }
}
