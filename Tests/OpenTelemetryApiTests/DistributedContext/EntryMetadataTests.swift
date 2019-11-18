//
//  EntryMetadataTests.swift
//  OpenTelemetrySwift iOSTests
//
//  Created by Ignacio Bonafonte on 14/11/2019.
//

@testable import OpenTelemetryApi
import XCTest

class EntryMetadataTests: XCTestCase {
    func testGetEntryTtl() {
        let entryMetadata = EntryMetadata(entryTtl: .noPropagation)
        XCTAssertEqual(entryMetadata.entryTtl, EntryTtl.noPropagation)
    }

    func testEquals() {
        XCTAssertEqual(EntryMetadata(entryTtl: .noPropagation), EntryMetadata(entryTtl: .noPropagation))
        XCTAssertNotEqual(EntryMetadata(entryTtl: .noPropagation), EntryMetadata(entryTtl: .unlimitedPropagation))
    }
}
