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

class HttpTraceContextFormatTest: XCTestCase {
    let tracestate_default = Tracestate()
    let tracestate_not_default = Tracestate().setting(key: "foo", value: "bar").setting(key: "bar", value: "baz")
    let traceId_base16 = "ff000000000000000000000000000041"
    var traceId: TraceId!
    let spanId_base16 = "ff00000000000041"
    var spanId: SpanId!
    let sampledTraceOptions_bytes: UInt8 = 1
    var sampledTraceOptions: TraceFlags!
    var traceParentHeaderSampled: String!
    var traceParentHeaderNotSampled: String!

    let tracestateNotDefaultEncoding = "foo=bar,bar=baz"
    let httpTraceContext = HttpTraceContextFormat()

    struct TestSetter: Setter {
        func set(carrier: inout [String: String], key: String, value: String) {
            carrier[key] = value
        }
    }

    struct TestGetter: Getter {
        func get(carrier: [String: String], key: String) -> [String]? {
            if let value = carrier[key] {
                return [value]
            }
            return nil
        }
    }

    let setter = TestSetter()
    let getter = TestGetter()

    override func setUp() {
        traceId = TraceId(fromHexString: traceId_base16)
        spanId = SpanId(fromHexString: spanId_base16)
        sampledTraceOptions = TraceFlags(fromByte: sampledTraceOptions_bytes)
        traceParentHeaderSampled = "00-" + traceId_base16 + "-" + spanId_base16 + "-01"
        traceParentHeaderNotSampled = "00-" + traceId_base16 + "-" + spanId_base16 + "-00"
    }

    func testInject_SampledContext() {
        var carrier = [String: String]()
        httpTraceContext.inject(spanContext: SpanContext.create(traceId: traceId, spanId: spanId, traceFlags: sampledTraceOptions, tracestate: tracestate_default), carrier: &carrier, setter: setter)
        XCTAssertEqual(carrier[HttpTraceContextFormat.traceparent], traceParentHeaderSampled)
    }

    func testInject_NotSampledContext() {
        var carrier = [String: String]()
        httpTraceContext.inject(spanContext: SpanContext.create(traceId: traceId, spanId: spanId, traceFlags: TraceFlags(), tracestate: tracestate_default), carrier: &carrier, setter: setter)
        XCTAssertEqual(carrier[HttpTraceContextFormat.traceparent], traceParentHeaderNotSampled)
    }

    func testInject_SampledContext_WithTraceState() {
        var carrier = [String: String]()
        httpTraceContext.inject(spanContext: SpanContext.create(traceId: traceId, spanId: spanId, traceFlags: sampledTraceOptions, tracestate: tracestate_not_default), carrier: &carrier, setter: setter)
        XCTAssertEqual(carrier[HttpTraceContextFormat.traceparent], traceParentHeaderSampled)
        XCTAssertEqual(carrier[HttpTraceContextFormat.tracestate], tracestateNotDefaultEncoding)
    }

    func testInject_NotSampledContext_WithTraceState() {
        var carrier = [String: String]()
        httpTraceContext.inject(spanContext: SpanContext.create(traceId: traceId, spanId: spanId, traceFlags: TraceFlags(), tracestate: tracestate_not_default), carrier: &carrier, setter: setter)
        XCTAssertEqual(carrier[HttpTraceContextFormat.traceparent], traceParentHeaderNotSampled)
        XCTAssertEqual(carrier[HttpTraceContextFormat.tracestate], tracestateNotDefaultEncoding)
    }

    func testExtract_SampledContext() {
        var carrier = [String: String]()
        carrier[HttpTraceContextFormat.traceparent] = traceParentHeaderSampled
        XCTAssertEqual(httpTraceContext.extract(carrier: carrier, getter: getter), SpanContext.createFromRemoteParent(traceId: traceId, spanId: spanId, traceFlags: sampledTraceOptions, tracestate: tracestate_not_default))
    }

    func testExtract_NotSampledContext() {
        var carrier = [String: String]()
        carrier[HttpTraceContextFormat.traceparent] = traceParentHeaderNotSampled
        XCTAssertEqual(httpTraceContext.extract(carrier: carrier, getter: getter), SpanContext.createFromRemoteParent(traceId: traceId, spanId: spanId, traceFlags: TraceFlags(), tracestate: tracestate_default))
    }

    func testExtract_SampledContext_WithTraceState() {
        var carrier = [String: String]()
        carrier[HttpTraceContextFormat.traceparent] = traceParentHeaderSampled
        carrier[HttpTraceContextFormat.tracestate] = tracestateNotDefaultEncoding
        XCTAssertEqual(httpTraceContext.extract(carrier: carrier, getter: getter), SpanContext.createFromRemoteParent(traceId: traceId, spanId: spanId, traceFlags: sampledTraceOptions, tracestate: tracestate_not_default))
    }

    func testExtract_NotSampledContext_WithTraceState() {
        var carrier = [String: String]()
        carrier[HttpTraceContextFormat.traceparent] = traceParentHeaderNotSampled
        carrier[HttpTraceContextFormat.tracestate] = tracestateNotDefaultEncoding
        XCTAssertEqual(httpTraceContext.extract(carrier: carrier, getter: getter), SpanContext.createFromRemoteParent(traceId: traceId, spanId: spanId, traceFlags: TraceFlags(), tracestate: tracestate_not_default))
    }

    func testExtract_NotSampledContext_NextVersion() {
        var carrier = [String: String]()
        carrier[HttpTraceContextFormat.traceparent] = "01-" + traceId_base16 + "-" + spanId_base16 + "-00-02"
        XCTAssertEqual(httpTraceContext.extract(carrier: carrier, getter: getter), SpanContext.createFromRemoteParent(traceId: traceId, spanId: spanId, traceFlags: TraceFlags(), tracestate: tracestate_default))
    }

    func testExtract_NotSampledContext_EmptyTraceState() {
        var carrier = [String: String]()
        carrier[HttpTraceContextFormat.traceparent] = traceParentHeaderNotSampled
        carrier[HttpTraceContextFormat.tracestate] = ""
        XCTAssertEqual(httpTraceContext.extract(carrier: carrier, getter: getter), SpanContext.createFromRemoteParent(traceId: traceId, spanId: spanId, traceFlags: TraceFlags(), tracestate: tracestate_default))
    }

    func testExtract_NotSampledContext_TraceStateWithSpaces() {
        var carrier = [String: String]()
        carrier[HttpTraceContextFormat.traceparent] = traceParentHeaderNotSampled
        carrier[HttpTraceContextFormat.tracestate] = "foo=bar   ,    bar=baz"
        XCTAssertEqual(httpTraceContext.extract(carrier: carrier, getter: getter), SpanContext.createFromRemoteParent(traceId: traceId, spanId: spanId, traceFlags: TraceFlags(), tracestate: tracestate_not_default))
    }

    func testExtract_InvalidTraceId() {
        var invalidHeaders = [String: String]()
        invalidHeaders[HttpTraceContextFormat.traceparent] = "00-" + "abcdefghijklmnopabcdefghijklmnop" + "-" + spanId_base16 + "-01"
        XCTAssertNil(httpTraceContext.extract(carrier: invalidHeaders, getter: getter))
    }

    func testExtract_InvalidTraceId_Size() {
        var invalidHeaders = [String: String]()
        invalidHeaders[HttpTraceContextFormat.traceparent] = "00-" + traceId_base16 + "00-" + spanId_base16 + "-01"
        XCTAssertNil(httpTraceContext.extract(carrier: invalidHeaders, getter: getter))
    }

    func testExtract_InvalidSpanId() {
        var invalidHeaders = [String: String]()
        invalidHeaders[HttpTraceContextFormat.traceparent] = "00-" + traceId_base16 + "-" + "abcdefghijklmnop" + "-01"
        XCTAssertNil(httpTraceContext.extract(carrier: invalidHeaders, getter: getter))
    }

    func testExtract_InvalidSpanId_Size() {
        var invalidHeaders = [String: String]()
        invalidHeaders[HttpTraceContextFormat.traceparent] = "00-" + traceId_base16 + "-" + spanId_base16 + "00-01"
        XCTAssertNil(httpTraceContext.extract(carrier: invalidHeaders, getter: getter))
    }

    func testExtract_InvalidTraceFlags() {
        var invalidHeaders = [String: String]()
        invalidHeaders[HttpTraceContextFormat.traceparent] = "00-" + traceId_base16 + "-" + spanId_base16 + "-gh"
        XCTAssertNil(httpTraceContext.extract(carrier: invalidHeaders, getter: getter))
    }

    func testExtract_InvalidTraceFlags_Size() {
        var invalidHeaders = [String: String]()
        invalidHeaders[HttpTraceContextFormat.traceparent] = "00-" + traceId_base16 + "-" + spanId_base16 + "-0100"
        XCTAssertNil(httpTraceContext.extract(carrier: invalidHeaders, getter: getter))
    }

//    func testExtract_InvalidTracestate_EntriesDelimiter() {
//        var invalidHeaders = [String: String]()
//        invalidHeaders[HttpTraceContextFormat.traceparent] = "00-" + traceId_base16 + "-" + spanId_base16 + "-01"
//        invalidHeaders[HttpTraceContextFormat.tracestate] = "foo=bar;test=test"
//        XCTAssertNil(httpTraceContext.extract(carrier: invalidHeaders, getter: getter))
//    }//
//    func testExtract_InvalidTracestate_KeyValueDelimiter() {
//        var invalidHeaders = [String: String]()
//        invalidHeaders[HttpTraceContextFormat.traceparent] = "00-" + traceId_base16 + "-" + spanId_base16 + "-01"
//        invalidHeaders[HttpTraceContextFormat.tracestate] = "foo=bar,test-test"
//        XCTAssertNil(httpTraceContext.extract(carrier: invalidHeaders, getter: getter))
//    }//
//    func testExtract_InvalidTracestate_OneString() {
//        var invalidHeaders = [String: String]()
//        invalidHeaders[HttpTraceContextFormat.traceparent] = "00-" + traceId_base16 + "-" + spanId_base16 + "-01"
//        invalidHeaders[HttpTraceContextFormat.tracestate] = "test-test"
//        XCTAssertNil(httpTraceContext.extract(carrier: invalidHeaders, getter: getter))
//    }

    func testFieldsList() {
        XCTAssertTrue(httpTraceContext.fields.contains(HttpTraceContextFormat.traceparent))
        XCTAssertTrue(httpTraceContext.fields.contains(HttpTraceContextFormat.traceparent))
        XCTAssertEqual(httpTraceContext.fields.count, 2)
    }

    func testHeaderNames() {
        XCTAssertEqual(HttpTraceContextFormat.traceparent, "traceparent")
        XCTAssertEqual(HttpTraceContextFormat.tracestate, "tracestate")
    }
}
