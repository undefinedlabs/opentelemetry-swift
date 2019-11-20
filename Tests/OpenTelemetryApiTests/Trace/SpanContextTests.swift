//
//  SpanContextTests.swift
//
//  Created by Ignacio Bonafonte on 21/10/2019.
//

@testable import OpenTelemetryApi
import XCTest

final class SpanContextTests: XCTestCase {
    let firstTraceIdBytes: [UInt8] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, UInt8(ascii: "a")]
    let secondTraceIdBytes: [UInt8] = [0, 0, 0, 0, 0, 0, 0, UInt8(ascii: "0"), 0, 0, 0, 0, 0, 0, 0, 0]
    let firstSpanIdBytes: [UInt8] = [0, 0, 0, 0, 0, 0, 0, UInt8(ascii: "a")]
    let secondSpanIdBytes: [UInt8] = [UInt8(ascii: "0"), 0, 0, 0, 0, 0, 0, 0]

    var firstTracestate: Tracestate!
    var secondTracestate: Tracestate!
    var emptyTracestate: Tracestate!

    var first: SpanContext!
    var second: SpanContext!
    var remote: SpanContext!

    override func setUp() {
        firstTracestate = Tracestate().setting(key: "foo", value: "bar")
        secondTracestate = Tracestate().setting(key: "foo", value: "baz")
        emptyTracestate = Tracestate()

        first = SpanContext.create(traceId: TraceId(fromBytes: firstTraceIdBytes), spanId: SpanId(fromBytes: firstSpanIdBytes), traceFlags: TraceFlags(), tracestate: firstTracestate)
        second = SpanContext.create(traceId: TraceId(fromBytes: secondTraceIdBytes), spanId: SpanId(fromBytes: secondSpanIdBytes), traceFlags: TraceFlags().settingIsSampled(true), tracestate: secondTracestate)
        remote = SpanContext.createFromRemoteParent(traceId: TraceId(fromBytes: secondTraceIdBytes), spanId: SpanId(fromBytes: secondSpanIdBytes), traceFlags: TraceFlags().settingIsSampled(true), tracestate: emptyTracestate)
    }

    func testInvalidSpanContext() {
        XCTAssertEqual(SpanContext.invalid.traceId, TraceId.invalid)
        XCTAssertEqual(SpanContext.invalid.spanId, SpanId.invalid)
        XCTAssertEqual(SpanContext.invalid.traceFlags, TraceFlags())
    }

    func testIsValid() {
        XCTAssertFalse(SpanContext.invalid.isValid)
        XCTAssertFalse(SpanContext.create(traceId: TraceId(fromBytes: firstTraceIdBytes), spanId: SpanId.invalid, traceFlags: TraceFlags(), tracestate: emptyTracestate).isValid)
        XCTAssertFalse(SpanContext.create(traceId: TraceId.invalid, spanId: SpanId.invalid, traceFlags: TraceFlags(), tracestate: emptyTracestate).isValid)
        XCTAssertFalse(SpanContext.create(traceId: TraceId.invalid, spanId: SpanId(fromBytes: firstSpanIdBytes), traceFlags: TraceFlags(), tracestate: emptyTracestate).isValid)
        XCTAssertTrue(first.isValid)
        XCTAssertTrue(second.isValid)
    }

    func testGetTraceId() {
        XCTAssertEqual(first.traceId, TraceId(fromBytes: firstTraceIdBytes))
        XCTAssertEqual(second.traceId, TraceId(fromBytes: secondTraceIdBytes))
    }

    func testGetSpanId() {
        XCTAssertEqual(first.spanId, SpanId(fromBytes: firstSpanIdBytes))
        XCTAssertEqual(second.spanId, SpanId(fromBytes: secondSpanIdBytes))
    }

    func testGetTraceFlags() {
        XCTAssertEqual(first.traceFlags, TraceFlags())
        XCTAssertEqual(second.traceFlags, TraceFlags().settingIsSampled(true))
    }

    func testGetTracestate() {
        XCTAssertEqual(first.tracestate, firstTracestate)
        XCTAssertEqual(second.tracestate, secondTracestate)
    }

    func testIsRemote() {
        XCTAssertFalse(first.isRemote)
        XCTAssertFalse(second.isRemote)
        XCTAssertTrue(remote.isRemote)
    }

    func testSpanContext_EqualsAndHashCode() {
        XCTAssertEqual(first, SpanContext.create(traceId: TraceId(fromBytes: firstTraceIdBytes), spanId: SpanId(fromBytes: firstSpanIdBytes), traceFlags: TraceFlags(), tracestate: emptyTracestate))
        XCTAssertEqual(first, SpanContext.create(traceId: TraceId(fromBytes: firstTraceIdBytes), spanId: SpanId(fromBytes: firstSpanIdBytes), traceFlags: TraceFlags().settingIsSampled(false), tracestate: firstTracestate))
        XCTAssertEqual(second, SpanContext.create(traceId: TraceId(fromBytes: secondTraceIdBytes), spanId: SpanId(fromBytes: secondSpanIdBytes), traceFlags: TraceFlags().settingIsSampled(true), tracestate: secondTracestate))
        XCTAssertEqual(remote, SpanContext.createFromRemoteParent(traceId: TraceId(fromBytes: secondTraceIdBytes), spanId: SpanId(fromBytes: secondSpanIdBytes), traceFlags: TraceFlags().settingIsSampled(true), tracestate: emptyTracestate))
        XCTAssertNotEqual(first, second)
        XCTAssertNotEqual(first, SpanContext.create(traceId: TraceId(fromBytes: secondTraceIdBytes), spanId: SpanId(fromBytes: secondSpanIdBytes), traceFlags: TraceFlags().settingIsSampled(true), tracestate: secondTracestate))
        XCTAssertNotEqual(first, remote)
        XCTAssertNotEqual(first, SpanContext.createFromRemoteParent(traceId: TraceId(fromBytes: secondTraceIdBytes), spanId: SpanId(fromBytes: secondSpanIdBytes), traceFlags: TraceFlags().settingIsSampled(true), tracestate: emptyTracestate))
        XCTAssertNotEqual(SpanContext.create(traceId: TraceId(fromBytes: firstTraceIdBytes), spanId: SpanId(fromBytes: firstSpanIdBytes), traceFlags: TraceFlags(), tracestate: emptyTracestate), second)
        XCTAssertNotEqual(SpanContext.create(traceId: TraceId(fromBytes: firstTraceIdBytes), spanId: SpanId(fromBytes: firstSpanIdBytes), traceFlags: TraceFlags(), tracestate: emptyTracestate), SpanContext.create(traceId: TraceId(fromBytes: secondTraceIdBytes), spanId: SpanId(fromBytes: secondSpanIdBytes), traceFlags: TraceFlags().settingIsSampled(true), tracestate: secondTracestate))
        XCTAssertNotEqual(SpanContext.create(traceId: TraceId(fromBytes: firstTraceIdBytes), spanId: SpanId(fromBytes: firstSpanIdBytes), traceFlags: TraceFlags(), tracestate: emptyTracestate), remote)
        XCTAssertNotEqual(SpanContext.create(traceId: TraceId(fromBytes: firstTraceIdBytes), spanId: SpanId(fromBytes: firstSpanIdBytes), traceFlags: TraceFlags(), tracestate: emptyTracestate), SpanContext.createFromRemoteParent(traceId: TraceId(fromBytes: secondTraceIdBytes), spanId: SpanId(fromBytes: secondSpanIdBytes), traceFlags: TraceFlags().settingIsSampled(true), tracestate: emptyTracestate))
        XCTAssertNotEqual(SpanContext.create(traceId: TraceId(fromBytes: firstTraceIdBytes), spanId: SpanId(fromBytes: firstSpanIdBytes), traceFlags: TraceFlags().settingIsSampled(false), tracestate: firstTracestate), second)
        XCTAssertNotEqual(SpanContext.create(traceId: TraceId(fromBytes: firstTraceIdBytes), spanId: SpanId(fromBytes: firstSpanIdBytes), traceFlags: TraceFlags().settingIsSampled(false), tracestate: firstTracestate), SpanContext.create(traceId: TraceId(fromBytes: secondTraceIdBytes), spanId: SpanId(fromBytes: secondSpanIdBytes), traceFlags: TraceFlags().settingIsSampled(true), tracestate: secondTracestate))
        XCTAssertNotEqual(SpanContext.create(traceId: TraceId(fromBytes: firstTraceIdBytes), spanId: SpanId(fromBytes: firstSpanIdBytes), traceFlags: TraceFlags().settingIsSampled(false), tracestate: firstTracestate), remote)
        XCTAssertNotEqual(SpanContext.create(traceId: TraceId(fromBytes: firstTraceIdBytes), spanId: SpanId(fromBytes: firstSpanIdBytes), traceFlags: TraceFlags().settingIsSampled(false), tracestate: firstTracestate), SpanContext.createFromRemoteParent(traceId: TraceId(fromBytes: secondTraceIdBytes), spanId: SpanId(fromBytes: secondSpanIdBytes), traceFlags: TraceFlags().settingIsSampled(true), tracestate: emptyTracestate))
        XCTAssertNotEqual(second, remote)
        XCTAssertNotEqual(second, SpanContext.createFromRemoteParent(traceId: TraceId(fromBytes: secondTraceIdBytes), spanId: SpanId(fromBytes: secondSpanIdBytes), traceFlags: TraceFlags().settingIsSampled(true), tracestate: secondTracestate))
        XCTAssertNotEqual(SpanContext.create(traceId: TraceId(fromBytes: secondTraceIdBytes), spanId: SpanId(fromBytes: secondSpanIdBytes), traceFlags: TraceFlags().settingIsSampled(true), tracestate: secondTracestate), remote)
        XCTAssertNotEqual(SpanContext.create(traceId: TraceId(fromBytes: secondTraceIdBytes), spanId: SpanId(fromBytes: secondSpanIdBytes), traceFlags: TraceFlags().settingIsSampled(true), tracestate: secondTracestate), SpanContext.createFromRemoteParent(traceId: TraceId(fromBytes: secondTraceIdBytes), spanId: SpanId(fromBytes: secondSpanIdBytes), traceFlags: TraceFlags().settingIsSampled(true), tracestate: secondTracestate))
    }

    func testSpanContext_ToString() {
        XCTAssert(first.description.contains(TraceId(fromBytes: firstTraceIdBytes).description))
        XCTAssert(first.description.contains(SpanId(fromBytes: firstSpanIdBytes).description))
        XCTAssert(first.description.contains(TraceFlags().description))
        XCTAssert(second.description.contains(TraceId(fromBytes: secondTraceIdBytes).description))
        XCTAssert(second.description.contains(SpanId(fromBytes: secondSpanIdBytes).description))
        XCTAssert(second.description.contains(TraceFlags().settingIsSampled(true).description))
    }
}
