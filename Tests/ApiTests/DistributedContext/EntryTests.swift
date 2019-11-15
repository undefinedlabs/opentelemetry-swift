//
//  EntryTests.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 14/11/2019.
//

@testable import Api
import XCTest

class EntryTests: XCTestCase {
    let key = EntryKey(name: "KEY")!
    let key2 = EntryKey(name: "KEY2")!
    let value = EntryValue(string: "VALUE")!
    let value2 = EntryValue(string: "VALUE2")!
    let metadataUnlimitedPropagation = EntryMetadata(entryTtl: .unlimitedPropagation)
    let metadataNoPropagation = EntryMetadata(entryTtl: .noPropagation)

    func testGetKey() {
        XCTAssertEqual(Entry(key: key, value: value, entryMetadata: metadataUnlimitedPropagation).key, key)
    }

    func testGetEntryMetadata() {
        XCTAssertEqual(Entry(key: key, value: value, entryMetadata: metadataNoPropagation).metadata, metadataNoPropagation)
    }

    func testEntryEquals() {
        XCTAssertEqual(Entry(key: key, value: value, entryMetadata: metadataUnlimitedPropagation), Entry(key: key, value: value, entryMetadata: metadataUnlimitedPropagation))
        XCTAssertNotEqual(Entry(key: key, value: value, entryMetadata: metadataUnlimitedPropagation), Entry(key: key, value: value2, entryMetadata: metadataUnlimitedPropagation))
        XCTAssertNotEqual(Entry(key: key, value: value, entryMetadata: metadataUnlimitedPropagation), Entry(key: key2, value: value, entryMetadata: metadataUnlimitedPropagation))
        XCTAssertNotEqual(Entry(key: key, value: value, entryMetadata: metadataUnlimitedPropagation), Entry(key: key, value: value, entryMetadata: metadataNoPropagation))
        XCTAssertEqual(Entry(key: key, value: value2, entryMetadata: metadataUnlimitedPropagation), Entry(key: key, value: value2, entryMetadata: metadataUnlimitedPropagation))
        XCTAssertNotEqual(Entry(key: key, value: value2, entryMetadata: metadataUnlimitedPropagation), Entry(key: key2, value: value, entryMetadata: metadataUnlimitedPropagation))
        XCTAssertNotEqual(Entry(key: key, value: value2, entryMetadata: metadataUnlimitedPropagation), Entry(key: key, value: value, entryMetadata: metadataNoPropagation))
        XCTAssertEqual(Entry(key: key2, value: value, entryMetadata: metadataUnlimitedPropagation), Entry(key: key2, value: value, entryMetadata: metadataUnlimitedPropagation))
        XCTAssertNotEqual(Entry(key: key2, value: value, entryMetadata: metadataUnlimitedPropagation), Entry(key: key, value: value, entryMetadata: metadataNoPropagation))
        XCTAssertEqual(Entry(key: key, value: value, entryMetadata: metadataNoPropagation), Entry(key: key, value: value, entryMetadata: metadataNoPropagation))
    }
}
