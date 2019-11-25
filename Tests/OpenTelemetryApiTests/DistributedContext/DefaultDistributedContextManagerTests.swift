/*
 * Copyright 2019, Undefined Labs
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

@testable import OpenTelemetryApi
import XCTest

fileprivate let key = EntryKey(name: "key")!
fileprivate let value = EntryValue(string: "value")!

class TestDistributedContext: DistributedContext {
    static func contextBuilder() -> DistributedContextBuilder {
        EmptyDistributedContextBuilder()
    }

    func getEntries() -> [Entry] {
        return [Entry(key: key, value: value, entryMetadata: EntryMetadata(entryTtl: .unlimitedPropagation))]
    }

    func getEntryValue(key: EntryKey) -> EntryValue? {
        return value
    }
}

class DefaultDistributedContextManagerTests: XCTestCase {
    let defaultDistributedContextManager = DefaultDistributedContextManager.instance
    let distContext = TestDistributedContext()

    func testBuilderMethod() {
        let builder = defaultDistributedContextManager.contextBuilder()
        XCTAssertEqual(builder.build().getEntries().count, 0)
    }

    func testGetCurrentContext_DefaultContext() {
        XCTAssertTrue(defaultDistributedContextManager.getCurrentContext() === EmptyDistributedContext.instance)
    }

    func testGetCurrentContext_ContextSetToNil() {
        let distContext = defaultDistributedContextManager.getCurrentContext()
        XCTAssertNotNil(distContext)
        XCTAssertEqual(distContext.getEntries().count, 0)
    }

    func testWithContext() {
        XCTAssertTrue(defaultDistributedContextManager.getCurrentContext() === EmptyDistributedContext.instance)
        var wtm = defaultDistributedContextManager.withContext(distContext: distContext)
        XCTAssertTrue(defaultDistributedContextManager.getCurrentContext() === distContext)
        wtm.close()
        XCTAssertTrue(defaultDistributedContextManager.getCurrentContext() === EmptyDistributedContext.instance)
    }

    func testWithContextUsingWrap() {
        let expec = expectation(description: "testWithContextUsingWrap")
        var wtm = defaultDistributedContextManager.withContext(distContext: distContext)
        XCTAssertTrue(defaultDistributedContextManager.getCurrentContext() === distContext)
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            semaphore.wait()
            XCTAssertTrue(self.defaultDistributedContextManager.getCurrentContext() === self.distContext)
            expec.fulfill()
        }
        wtm.close()
        XCTAssertTrue(defaultDistributedContextManager.getCurrentContext() === EmptyDistributedContext.instance)
        semaphore.signal()
        waitForExpectations(timeout: 30) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
