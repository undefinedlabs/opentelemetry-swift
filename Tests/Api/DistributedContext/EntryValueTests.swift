//
//  EntryValueTests.swift
//  OpenTelemetrySwift iOSTests
//
//  Created by Ignacio Bonafonte on 14/11/2019.
//

@testable import OpenTelemetrySwift
import XCTest

class EntryValueTests: XCTestCase {
    func testMaxLength() {
        XCTAssertEqual(EntryValue.maxLength, 255)
    }

    func testAsString() {
        XCTAssertEqual(EntryValue(string: "foo")?.string, "foo")
    }

    func testCreate_AllowEntryValueWithMaxLength() {
        let value = String(repeating: "k", count: EntryValue.maxLength)
        XCTAssertEqual(EntryValue(string: value)?.string, value)
    }

    func testCreate_DisallowEntryValueOverMaxLength() {
        let value = String(repeating: "k", count: EntryValue.maxLength + 1)
        XCTAssertNil(EntryValue(string: value)?.string)
    }

    func testDisallowEntryValueWithUnprintableChars() {
        let value = String("\0")
        XCTAssertNil(EntryValue(string: value)?.string)
    }

    func testEntryValueEquals() {
        XCTAssertEqual(EntryValue(string: "foo"), EntryValue(string: "foo"))
        XCTAssertNotEqual(EntryValue(string: "foo"), EntryValue(string: "bar"))
    }
}
