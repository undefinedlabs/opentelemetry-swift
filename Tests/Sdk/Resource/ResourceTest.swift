//
//  ResourceTest.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 06/11/2019.
//

@testable import OpenTelemetrySwift
import XCTest

class ResourceTest: XCTestCase {
    var defaultResource = Resource(labels: [String: String]())
    var resource1: Resource!
    var resource2: Resource!

    override func setUp() {
        let labelMap1 = ["a": "1", "b": "2"]
        let labelMap2 = ["a": "1", "b": "3", "c": "4"]
        resource1 = Resource(labels: labelMap1)
        resource2 = Resource(labels: labelMap2)
    }

    func testCreate() {
        let labelMap = ["a": "1", "b": "2"]
        let resource = Resource(labels: labelMap)
        XCTAssertEqual(resource.labels.count, 2)
        XCTAssertEqual(resource.labels, labelMap)
        let resource1 = Resource(labels: [String: String]())
        XCTAssertEqual(resource1.labels.count, 0)
    }

    func testResourceEquals() {
        let labelMap1 = ["a": "1", "b": "2"]
        let labelMap2 = ["a": "1", "b": "3", "c": "4"]
        XCTAssertEqual(Resource(labels: labelMap1), Resource(labels: labelMap1))
        XCTAssertNotEqual(Resource(labels: labelMap1), Resource(labels: labelMap2))
    }

    func testMergeResources() {
        let expectedLabelMap = ["a": "1", "b": "2", "c": "4"]
        let resource = defaultResource.merging(other: resource1).merging(other: resource2)
        XCTAssertEqual(resource.labels, expectedLabelMap)
    }

    func testMergeResources_Resource1() {
        let expectedLabelMap = ["a": "1", "b": "2"]
        let resource = defaultResource.merging(other: resource1)
        XCTAssertEqual(resource.labels, expectedLabelMap)
    }

}
