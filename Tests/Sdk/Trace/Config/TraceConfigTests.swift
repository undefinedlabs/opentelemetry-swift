//
//  TraceConfigTests.swift
//  OpenTelemetrySwift iOSTests
//
//  Created by Ignacio Bonafonte on 08/11/2019.
//

@testable import OpenTelemetrySwift
import XCTest

class TraceConfigTests: XCTestCase {
    func testDefaultTraceConfig() {
        XCTAssertTrue(TraceConfig().sampler === Samplers.alwaysSample)
        XCTAssertEqual(TraceConfig().maxNumberOfAttributes, 32)
        XCTAssertEqual(TraceConfig().maxNumberOfEvents, 128)
        XCTAssertEqual(TraceConfig().maxNumberOfLinks, 32)
        XCTAssertEqual(TraceConfig().maxNumberOfAttributesPerEvent, 32)
        XCTAssertEqual(TraceConfig().maxNumberOfAttributesPerLink, 32)
    }

    func testUpdateTraceConfig_All() {
        let traceConfig = TraceConfig().settingSampler( Samplers.neverSample).settingMaxNumberOfAttributes(8).settingMaxNumberOfEvents(10).settingMaxNumberOfLinks(11).settingMaxNumberOfAttributesPerEvent(1).settingMaxNumberOfAttributesPerLink(2)
        XCTAssertTrue(traceConfig.sampler === Samplers.neverSample)
        XCTAssertEqual(traceConfig.maxNumberOfAttributes, 8)
        XCTAssertEqual(traceConfig.maxNumberOfEvents, 10)
        XCTAssertEqual(traceConfig.maxNumberOfLinks, 11)
        XCTAssertEqual(traceConfig.maxNumberOfAttributesPerEvent, 1)
        XCTAssertEqual(traceConfig.maxNumberOfAttributesPerLink, 2)
    }
}
