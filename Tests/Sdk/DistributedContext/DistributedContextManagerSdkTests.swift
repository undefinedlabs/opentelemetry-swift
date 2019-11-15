//
//  DistributedContextManagerSdkTests.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 15/11/2019.
//

@testable import OpenTelemetrySwift
import XCTest

class DistributedContextManagerSdkTests: XCTestCase {
    let distContext = DistributedContextMock()
    let contextManager = DistributedContextManagerSdk()

    func testGetCurrentContext_DefaultContext() {
        XCTAssertTrue(contextManager.getCurrentContext() === EmptyDistributedContext.instance)
    }

    func testWithDistributedContext() {
        XCTAssertTrue(contextManager.getCurrentContext() === EmptyDistributedContext.instance)
        var wtm = contextManager.withContext(distContext: distContext)
        XCTAssertTrue(contextManager.getCurrentContext() === distContext)
        wtm.close()
        XCTAssertTrue(contextManager.getCurrentContext() === EmptyDistributedContext.instance)
    }

    func testWithDistributedContextUsingWrap() {
        let expec = expectation(description: "testWithDistributedContextUsingWrap")
        var wtm = contextManager.withContext(distContext: distContext)
        XCTAssertTrue(contextManager.getCurrentContext() === distContext)
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            semaphore.wait()
            XCTAssertTrue(self.contextManager.getCurrentContext() === self.distContext)
            expec.fulfill()
        }
        wtm.close()
        semaphore.signal()
        waitForExpectations(timeout: 30) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
