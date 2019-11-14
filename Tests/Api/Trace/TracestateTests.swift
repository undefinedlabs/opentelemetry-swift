//
@testable import OpenTelemetrySwift
//  TracestateTests.swift
//
//
//  Created by Ignacio Bonafonte on 21/10/2019.
//
import XCTest

final class TracestateTests: XCTestCase {
    let first_key = "key_1"
    let second_key = "key_2"
    let first_value = "value_1"
    let second_value = "value_2"

    var empty: Tracestate!
    var firstTracestate: Tracestate!
    var secondTracestate: Tracestate!
    var multiValueTracestate: Tracestate!

    override func setUp() {
        empty = Tracestate()
        firstTracestate = empty.setting(key: first_key, value: first_value)
        secondTracestate = empty.setting(key: second_key, value: second_value)
        multiValueTracestate = empty.setting(key: first_key, value: first_value).setting(key: second_key, value: second_value)
    }

    func testGet() {
        XCTAssertEqual(firstTracestate.get(key: first_key), first_value)
        XCTAssertEqual(secondTracestate.get(key: second_key), second_value)
        XCTAssertEqual(multiValueTracestate.get(key: first_key), first_value)
        XCTAssertEqual(multiValueTracestate.get(key: second_key), second_value)
    }

    func testGetEntries() {
        XCTAssertEqual(firstTracestate.entries, [Tracestate.Entry(key: first_key, value: first_value)!])
        XCTAssertEqual(secondTracestate.entries, [Tracestate.Entry(key: second_key, value: second_value)!])
        XCTAssertEqual(multiValueTracestate.entries, [Tracestate.Entry(key: first_key, value: first_value)!, Tracestate.Entry(key: second_key, value: second_value)!])
    }

    func testDisallowsEmptyKey() {
        XCTAssertNil(Tracestate.Entry(key: "", value: first_value))
    }

    func testInvalidFirstKeyCharacter() {
        XCTAssertNil(Tracestate.Entry(key: "$_key", value: first_value))
    }

    func testFirstKeyCharacterDigitIsAllowed() {
        let result = Tracestate().setting(key: "1_key", value: first_value)
        XCTAssertEqual(result.get(key: "1_key"), first_value)
    }

    func testInvalidKeyCharacters() {
        XCTAssertNil(Tracestate.Entry(key: "kEy_1", value: first_value))
    }

    func testValidAtSignVendorNamePrefix() {
        let result = Tracestate().setting(key: "1@nr", value: first_value)
        XCTAssertEqual(result.get(key: "1@nr"), first_value)
    }

    func testMultipleAtSignNotAllowed() {
        XCTAssertNil(Tracestate.Entry(key: "1@n@r@", value: first_value))
    }

    func testInvalidKeySize() {
        let bigString = String(repeating: "a", count: 257)
        XCTAssertNil(Tracestate.Entry(key: bigString, value: first_value))
    }

    func testAllAllowedKeyCharacters() {
        let allowedChars = "abcdefghijklmnopqrstuvwxyz0123456789_-*/"
        let result = Tracestate().setting(key: allowedChars, value: first_value)
        XCTAssertEqual(result.get(key: allowedChars), first_value)
    }

    func testValueCannotContainEqual() {
        XCTAssertNil(Tracestate.Entry(key: first_key, value: "my_value=5"))
    }

    func testValueCannotContainComma() {
        XCTAssertNil(Tracestate.Entry(key: first_key, value: "first,second"))
    }

    func testValueCannotContainTrailingSpaces() {
        XCTAssertNil(Tracestate.Entry(key: first_key, value: "first "))
    }

    func testInvalidValueSize() {
        let bigString = String(repeating: "a", count: 257)
        XCTAssertNil(Tracestate.Entry(key: first_key, value: bigString))
    }

    func testAllAllowedValueCharacters() {
        var validCharacters = String()
        for i in 0x20 ... 0x7E {
            let char = Character(UnicodeScalar(i)!)
            if char == "," || char == "=" {
                continue
            }
            validCharacters.append(Character(UnicodeScalar(i)!))
        }
        let result = Tracestate().setting(key: first_key, value: validCharacters)
        XCTAssertEqual(result.get(key: first_key), validCharacters)
    }

    func testAddEntry() {
        XCTAssertEqual(firstTracestate.setting(key: second_key, value: second_value), multiValueTracestate)
    }

    func testUpdateEntry() {
        XCTAssertEqual(firstTracestate.setting(key: first_key, value: second_value).get(key: first_key), second_value)

        let updatedMultiValueTracestate = multiValueTracestate.setting(key: first_key, value: second_value)
        XCTAssertEqual(updatedMultiValueTracestate.get(key: first_key), second_value)
        XCTAssertEqual(updatedMultiValueTracestate.get(key: second_key), second_value)
    }

    func testAddAndUpdateEntry() {
        XCTAssertEqual(firstTracestate.setting(key: first_key, value: second_value).setting(key: second_key, value: first_value).entries,
                       [Tracestate.Entry(key: first_key, value: second_value)!, Tracestate.Entry(key: second_key, value: first_value)!])
    }

    func testAddSameKey() {
        XCTAssertEqual(firstTracestate.setting(key: first_key, value: second_value).setting(key: first_key, value: first_value).entries,
                       [Tracestate.Entry(key: first_key, value: first_value)!])
    }

    func testRemove() {
        XCTAssertEqual(multiValueTracestate.removing(key: second_key), firstTracestate)
    }

    func testAddAndRemoveEntry() {
        XCTAssertEqual(Tracestate().setting(key: first_key, value: second_value).removing(key: first_key), Tracestate())
    }

    func testTracestate_EqualsAndHashCode() {
        XCTAssertEqual(Tracestate(), Tracestate())
        XCTAssertNotEqual(Tracestate(), firstTracestate)
        XCTAssertNotEqual(Tracestate(), Tracestate().setting(key: first_key, value: first_value))
        XCTAssertNotEqual(Tracestate(), secondTracestate)
        XCTAssertNotEqual(Tracestate(), Tracestate().setting(key: second_key, value: second_value))
        XCTAssertEqual(firstTracestate, Tracestate().setting(key: first_key, value: first_value))
        XCTAssertNotEqual(firstTracestate, secondTracestate)
        XCTAssertNotEqual(firstTracestate, Tracestate().setting(key: second_key, value: second_value))
        XCTAssertEqual(secondTracestate, Tracestate().setting(key: second_key, value: second_value))
    }

    func testTracestate_ToString() {
        XCTAssertEqual("\(Tracestate())", "Tracestate(entries: [])")
    }

    static var allTests = [
        ("testGet", testGet),
        ("testGetEntries", testGetEntries),
        ("testDisallowsEmptyKey", testDisallowsEmptyKey),
        ("testInvalidFirstKeyCharacter", testInvalidFirstKeyCharacter),
        ("testFirstKeyCharacterDigitIsAllowed", testFirstKeyCharacterDigitIsAllowed),
        ("testInvalidKeyCharacters", testInvalidKeyCharacters),
        ("testValidAtSignVendorNamePrefix", testValidAtSignVendorNamePrefix),
        ("testMultipleAtSignNotAllowed", testMultipleAtSignNotAllowed),
        ("testInvalidKeySize", testInvalidKeySize),
        ("testAllAllowedKeyCharacters", testAllAllowedKeyCharacters),
        ("testValueCannotContainEqual", testValueCannotContainEqual),
        ("testValueCannotContainComma", testValueCannotContainComma),
        ("testValueCannotContainTrailingSpaces", testValueCannotContainTrailingSpaces),
        ("testInvalidValueSize", testInvalidValueSize),
        ("testAllAllowedValueCharacters", testAllAllowedValueCharacters),
        ("testAddEntry", testAddEntry),
        ("testUpdateEntry", testUpdateEntry),
        ("testAddAndUpdateEntry", testAddAndUpdateEntry),
        ("testAddSameKey", testAddSameKey),
        ("testRemove", testRemove),
        ("testAddAndRemoveEntry", testAddAndRemoveEntry),
        ("testTracestate_EqualsAndHashCode", testTracestate_EqualsAndHashCode),
        ("testTracestate_ToString", testTracestate_ToString),
    ]
}
