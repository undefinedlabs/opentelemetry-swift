//
//  StatusTests.swift
//
//
//  Created by Ignacio Bonafonte on 22/10/2019.
//

@testable import Api
import XCTest

final class StatusTests: XCTestCase {
    func testStatus_Ok() {
        XCTAssertEqual(Status.ok.canonicalCode, Status.CanonicalCode.ok)
        XCTAssertNil(Status.ok.statusDescription)
        XCTAssertTrue(Status.ok.isOk)
    }

    func testCreateStatus_WithDescription() {
        let status = Status.unknown.withDescription(description: "This is an error.")
        XCTAssertEqual(status.canonicalCode, Status.CanonicalCode.unknown)
        XCTAssertEqual(status.statusDescription, "This is an error.")
        XCTAssertFalse(status.isOk)
    }

    func testStatus_EqualsAndHashCode() {
        XCTAssertEqual(Status.ok, Status.ok.withDescription(description: nil))
        XCTAssertNotEqual(Status.ok, Status.cancelled.withDescription(description: "ThisIsAnError"))
        XCTAssertNotEqual(Status.ok, Status.unknown.withDescription(description: "ThisIsAnError"))
        XCTAssertNotEqual(Status.ok.withDescription(description: nil), Status.cancelled.withDescription(description: "ThisIsAnError"))
        XCTAssertNotEqual(Status.ok.withDescription(description: nil), Status.unknown.withDescription(description: "ThisIsAnError"))
        XCTAssertEqual(Status.cancelled.withDescription(description: "ThisIsAnError"), Status.cancelled.withDescription(description: "ThisIsAnError"))
        XCTAssertNotEqual(Status.cancelled.withDescription(description: "ThisIsAnError"), Status.unknown.withDescription(description: "ThisIsAnError"))
    }
}
