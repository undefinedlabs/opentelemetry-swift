//
//  DistributedContextSdkTest.swift
//
//  Created by Ignacio Bonafonte on 15/11/2019.
//

@testable import OpenTelemetrySdk
import OpenTelemetryApi
import XCTest

class DistributedContextSdkTests: XCTestCase {
    let contextManager = DistributedContextManagerSdk()

    let tmd = EntryMetadata(entryTtl: .unlimitedPropagation)

    let k1 = EntryKey(name: "k1")!
    let k2 = EntryKey(name: "k2")!

    let v1 = EntryValue(string: "v1")!
    let v2 = EntryValue(string: "v2")!

    var t1: Entry!
    var t2: Entry!

    override func setUp() {
        t1 = Entry(key: k1, value: v1, entryMetadata: tmd)
        t2 = Entry(key: k2, value: v2, entryMetadata: tmd)
    }

    func testGetEntries_empty() {
        let distContext = DistributedContextSdk.contextBuilder().build()
        XCTAssertEqual(distContext.getEntries().count, 0)
    }

    func testGetEntries_nonEmpty() {
        let distContext = DistributedContextTestUtil.listToDistributedContext(entries: [t1, t2])
        XCTAssertEqual(distContext.getEntries().sorted(), [t1, t2].sorted())
    }

    func testGetEntries_chain() {
        let t1alt = Entry(key: k1, value: v2, entryMetadata: tmd)
        let parent = DistributedContextTestUtil.listToDistributedContext(entries: [t1, t2])
        let distContext = DistributedContextSdk.contextBuilder().setParent(parent).put(key: t1alt.key, value: t1alt.value, metadata: t1alt.metadata).build()
        XCTAssertEqual(distContext.getEntries().sorted(), [t1alt, t2].sorted())
    }

    func testPut_newKey() {
        let distContext = DistributedContextTestUtil.listToDistributedContext(entries: [t1])
        XCTAssertEqual(contextManager.contextBuilder().setParent(distContext).put(key: k2, value: v2, metadata: tmd).build().getEntries().sorted(), [t1, t2].sorted())
    }

    func testPut_existingKey() {
        let distContext = DistributedContextTestUtil.listToDistributedContext(entries: [t1])
        XCTAssertEqual(contextManager.contextBuilder().setParent(distContext).put(key: k1, value: v2, metadata: tmd).build().getEntries(), [Entry(key: k1, value: v2, entryMetadata: tmd)])
    }

    func testPetParent_setNoParent() {
        let parent = DistributedContextTestUtil.listToDistributedContext(entries: [t1])
        let distContext = contextManager.contextBuilder().setParent(parent).setNoParent().build()
        XCTAssertEqual(distContext.getEntries().count, 0)
    }

    func testRemove_existingKey() {
        let builder = DistributedContextSdkBuilder()
        builder.put(key: t1.key, value: t1.value, metadata: t1.metadata)
        builder.put(key: t2.key, value: t2.value, metadata: t2.metadata)
        XCTAssertEqual(builder.remove(key: k1).build().getEntries(), [t2])
    }

    func testRemove_differentKey() {
        let builder = DistributedContextSdkBuilder()
        builder.put(key: t1.key, value: t1.value, metadata: t1.metadata)
        builder.put(key: t2.key, value: t2.value, metadata: t2.metadata)
        XCTAssertEqual(builder.remove(key: k2).build().getEntries(), [t1])
    }

    func testRemove_keyFromParent() {
        let distContext = DistributedContextTestUtil.listToDistributedContext(entries: [t1, t2])
        XCTAssertEqual(contextManager.contextBuilder().setParent(distContext).remove(key: k1).build().getEntries(), [t2])
    }

    func testEquals() {
        XCTAssertEqual(contextManager.contextBuilder().put(key: k1, value: v1, metadata: tmd).put(key: k2, value: v2, metadata: tmd).build() as! DistributedContextSdk,
                       contextManager.contextBuilder().put(key: k1, value: v1, metadata: tmd).put(key: k2, value: v2, metadata: tmd).build() as! DistributedContextSdk)
        XCTAssertEqual(contextManager.contextBuilder().put(key: k1, value: v1, metadata: tmd).put(key: k2, value: v2, metadata: tmd).build() as! DistributedContextSdk,
                       contextManager.contextBuilder().put(key: k2, value: v2, metadata: tmd).put(key: k1, value: v1, metadata: tmd).build() as! DistributedContextSdk)
        XCTAssertNotEqual(contextManager.contextBuilder().put(key: k1, value: v1, metadata: tmd).put(key: k2, value: v2, metadata: tmd).build() as! DistributedContextSdk,
                          contextManager.contextBuilder().put(key: k1, value: v1, metadata: tmd).put(key: k2, value: v1, metadata: tmd).build() as! DistributedContextSdk)
        XCTAssertNotEqual(contextManager.contextBuilder().put(key: k1, value: v1, metadata: tmd).put(key: k2, value: v2, metadata: tmd).build() as! DistributedContextSdk,
                          contextManager.contextBuilder().put(key: k1, value: v2, metadata: tmd).put(key: k2, value: v1, metadata: tmd).build() as! DistributedContextSdk)
        XCTAssertNotEqual(contextManager.contextBuilder().put(key: k2, value: v2, metadata: tmd).put(key: k1, value: v1, metadata: tmd).build() as! DistributedContextSdk,
                          contextManager.contextBuilder().put(key: k1, value: v1, metadata: tmd).put(key: k2, value: v1, metadata: tmd).build() as! DistributedContextSdk)
        XCTAssertNotEqual(contextManager.contextBuilder().put(key: k2, value: v2, metadata: tmd).put(key: k1, value: v1, metadata: tmd).build() as! DistributedContextSdk,
                          contextManager.contextBuilder().put(key: k1, value: v2, metadata: tmd).put(key: k2, value: v1, metadata: tmd).build() as! DistributedContextSdk)
        XCTAssertNotEqual(contextManager.contextBuilder().put(key: k1, value: v1, metadata: tmd).put(key: k2, value: v1, metadata: tmd).build() as! DistributedContextSdk,
                          contextManager.contextBuilder().put(key: k1, value: v2, metadata: tmd).put(key: k2, value: v1, metadata: tmd).build() as! DistributedContextSdk)
    }
}
