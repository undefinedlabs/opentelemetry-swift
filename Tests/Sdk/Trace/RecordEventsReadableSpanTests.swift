//
//  RecordEventsReadableSpanTest.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 06/11/2019.
//
@testable import OpenTelemetrySwift
import XCTest

class RecordEventsReadableSpanTest: XCTestCase {
    let spanName = "MySpanName"
    let spanNewName = "NewName"
    let nanosPerSecond = 1000000000
    let millisPerSecond = 1000
    let traceId = TraceId.random()
    let spanId = SpanId.random()
    let parentSpanId = SpanId.random()
    var spanContext: SpanContext!
    let startTime = Timestamp(fromSeconds: 1000, nanoseconds: 0)
    var testClock: TestClock!
    var timestampConverter: TimestampConverter!
    let resource = Resource()
    var attributes = [String: AttributeValue]()
    var expectedAttributes = [String: AttributeValue]()
    let event = SimpleEvent(name: "event2", attributes: [String: AttributeValue]())
    var link: SimpleLink!
    let spanProcessor = SpanProcessorMock()

    override func setUp() {
        spanContext = SpanContext(traceId: traceId, spanId: spanId, traceFlags: TraceFlags(), tracestate: Tracestate())
        testClock = TestClock(timestamp: startTime)
        timestampConverter = TimestampConverter.now(clock: testClock)
        link = SimpleLink(context: spanContext)
        attributes["MyStringAttributeKey"] = AttributeValue.string("MyStringAttributeValue")
        attributes["MyLongAttributeKey"] = AttributeValue.int(123)
        attributes["MyBooleanAttributeKey"] = AttributeValue.bool(false)
        expectedAttributes.merge(attributes) { first, _ in first }
        expectedAttributes["MySingleStringAttributeKey"] = AttributeValue.string("MySingleStringAttributeValue")
    }

    func testNothingChangedAfterEnd() {
        let span = createTestSpan(kind: .internal)
        span.end()
        // Check that adding trace events or update fields after Span#end() does not throw any thrown
        // and are ignored.
        spanDoWork(span: span, status: .cancelled)
        let spanData = span.toSpanData()
        verifySpanData(spanData: spanData, attributes: [String: AttributeValue](), timedEvents: [TimedEvent](), links: [link], spanName: spanName, startTime: Timestamp(fromSeconds: startTime.getSeconds(), nanoseconds: 0), endTime: Timestamp(fromSeconds: startTime.getSeconds(), nanoseconds: 0), status: .ok)
    }

    func testEndSpanTwice_DoNotCrash() {
        let span = createTestSpan(kind: .internal)
        span.end()
        span.end()
    }

    func testToSpanData_ActiveSpan() {
        let span = createTestSpan(kind: .internal)
        spanDoWork(span: span, status: nil)
        let spanData = span.toSpanData()
        let timedEvent = TimedEvent(nanotime: Timestamp(fromSeconds: startTime.getSeconds() + 1, nanoseconds: 0).getNanos(), event: event)
        verifySpanData(spanData: spanData, attributes: expectedAttributes, timedEvents: [timedEvent], links: [link], spanName: spanNewName, startTime: Timestamp(fromSeconds: startTime.getSeconds(), nanoseconds: 0), endTime: Timestamp(fromSeconds: testClock.now.getSeconds(), nanoseconds: 0), status: .ok)
        span.end()
    }

    func testToSpanData_EndedSpan() {
        let span = createTestSpan(kind: .internal)
        spanDoWork(span: span, status: .cancelled)
        span.end()
        XCTAssertEqual(spanProcessor.onEndCalledTimes, 1)
        let spanData = span.toSpanData()
        let timedEvent = TimedEvent(nanotime: Timestamp(fromSeconds: startTime.getSeconds() + 1, nanoseconds: 0).getNanos(), event: event)
        verifySpanData(spanData: spanData, attributes: expectedAttributes, timedEvents: [timedEvent], links: [link], spanName: spanNewName, startTime: Timestamp(fromSeconds: startTime.getSeconds(), nanoseconds: 0), endTime: Timestamp(fromSeconds: testClock.now.getSeconds(), nanoseconds: 0), status: .cancelled)
    }

    func testToSpanData_RootSpan() {
        let span = createTestRootSpan()
        spanDoWork(span: span, status: nil)
        span.end()
        let spanData = span.toSpanData()
        XCTAssertNil(spanData.parentSpanId)
    }

    func testToSpanData_WithInitialAttributes() {
        let span = createTestSpan(attributes: attributes)
        span.end()
        let spanData = span.toSpanData()
        XCTAssertEqual(spanData.attributes.count, attributes.count)
    }

    func testSetStatus() {
        let span = createTestSpan(kind: .consumer)
        testClock.advanceMillis(millis: millisPerSecond)
        XCTAssertEqual(span.status, Status.ok)
        span.status = .cancelled
        XCTAssertEqual(span.status, Status.cancelled)
        span.end()
        XCTAssertEqual(span.status, Status.cancelled)
    }

    func testGetSpanKind() {
        let span = createTestSpan(kind: .server)
        XCTAssertEqual(span.kind, SpanKind.server)
        span.end()
    }

    func testGetAndUpdateSpanName() {
        let span = createTestRootSpan()
        XCTAssertEqual(span.name, spanName)
        span.updateName(name: spanNewName)
        XCTAssertEqual(span.name, spanNewName)
        span.end()
    }

    func testGetLatencyNs_ActiveSpan() {
        let span = createTestSpan(kind: .internal)
        testClock.advanceMillis(millis: millisPerSecond)
        let elapsedTimeNanos1 = (testClock.now.getSeconds() - startTime.getSeconds()) * nanosPerSecond
        XCTAssertEqual(span.getLatencyNs(), elapsedTimeNanos1)
        testClock.advanceMillis(millis: millisPerSecond)
        let elapsedTimeNanos2 = (testClock.now.getSeconds() - startTime.getSeconds()) * nanosPerSecond
        XCTAssertEqual(span.getLatencyNs(), elapsedTimeNanos2)
        span.end()
    }

    func testGetLatencyNs_EndedSpan() {
        let span = createTestSpan(kind: .internal)
        testClock.advanceMillis(millis: millisPerSecond)
        span.end()
        let elapsedTimeNanos = (testClock.now.getSeconds() - startTime.getSeconds()) * nanosPerSecond
        XCTAssertEqual(span.getLatencyNs(), elapsedTimeNanos)
        testClock.advanceMillis(millis: millisPerSecond)
        XCTAssertEqual(span.getLatencyNs(), elapsedTimeNanos)
    }

    func testSetAttribute() {
        let span = createTestRootSpan()
        span.setAttribute(key: "StringKey", value: "StringVal")
        span.setAttribute(key: "LongKey", value: 1000)
        span.setAttribute(key: "DoubleKey", value: 10.0)
        span.setAttribute(key: "BooleanKey", value: false)
        span.end()
        let spanData = span.toSpanData()
        XCTAssertEqual(spanData.attributes.count, 4)
    }

    func testAddEvent() {
        let span = createTestRootSpan()
        span.addEvent(name: "event1")
        span.addEvent(name: "event2", attributes: attributes)
        span.addEvent(event: SimpleEvent(name: "event3"))
        span.end()
        let spanData = span.toSpanData()
        XCTAssertEqual(spanData.timedEvents.count, 3)
    }

    func testDroppingAttributes() {
        // TODO: needs proper implementation of AttributesWithCapacity
//        let maxNumberOfAttributes = 8
//        let traceConfig = TraceConfig().settingMaxNumberOfAttributes(maxNumberOfAttributes)
//        let span = createTestSpan(config: traceConfig)
//
//        for i in 0 ..< 2 * maxNumberOfAttributes {
//            span.setAttribute(key: "MyStringAttributeKey\(i)", value: AttributeValue.int(i))
//        }
//        var spanData = span.toSpanData()
//        XCTAssertEqual(spanData.attributes?.count, maxNumberOfAttributes)
//
//        for i in 0 ..< maxNumberOfAttributes {
//            let expectedValue = AttributeValue.int(i + maxNumberOfAttributes)
//            XCTAssertEqual(spanData.attributes?["MyStringAttributeKey\(i + maxNumberOfAttributes)"], expectedValue)
//        }
//        span.end()
//        spanData = span.toSpanData()
//        XCTAssertEqual(spanData.attributes?.count, maxNumberOfAttributes)
//
//        for i in 0 ..< maxNumberOfAttributes {
//            let expectedValue = AttributeValue.int(i + maxNumberOfAttributes)
//            XCTAssertEqual(spanData.attributes?["MyStringAttributeKey\(i + maxNumberOfAttributes)"], expectedValue)
//        }
    }

    func testDroppingAndAddingAttributes() {
        // TODO: needs proper implementation of AttributesWithCapacity

//        let maxNumberOfAttributes = 8
//        let traceConfig = TraceConfig().settingMaxNumberOfAttributes(maxNumberOfAttributes)
//        let span = createTestSpan(config: traceConfig)
//        for i in 0 ..< 2 * maxNumberOfAttributes {
//            span.setAttribute(key: "MyStringAttributeKey\(i)", value: AttributeValue.int(i))
//        }
//        var spanData = span.toSpanData()
//        XCTAssertEqual(spanData.attributes?.count, maxNumberOfAttributes)
//
//        for i in 0 ..< maxNumberOfAttributes {
//            let expectedValue = AttributeValue.int(i + maxNumberOfAttributes)
//            XCTAssertEqual(spanData.attributes?["MyStringAttributeKey\(i + maxNumberOfAttributes)"], expectedValue)
//        }
//
//        for i in 0 ..< maxNumberOfAttributes / 2 {
//            span.setAttribute(key: "MyStringAttributeKey\(i)", value: AttributeValue.int(i))
//        }
//        spanData = span.toSpanData()
//        XCTAssertEqual(spanData.attributes?.count, maxNumberOfAttributes)
//        // Test that we still have in the attributes map the latest maxNumberOfAttributes / 2 entries.
//        for i in 0 ..< maxNumberOfAttributes / 2 {
//            let val = i + maxNumberOfAttributes * 3 / 2
//            let expectedValue = AttributeValue.int(val)
//            XCTAssertEqual(spanData.attributes?["MyStringAttributeKey\(val)"], expectedValue)
//        }
//        // Test that we have the newest re-added initial entries.
//        for i in 0 ..< maxNumberOfAttributes / 2 {
//            let expectedValue = AttributeValue.int(i)
//            XCTAssertEqual(spanData.attributes?["MyStringAttributeKey\(i)"], expectedValue)
//        }
//        span.end()
    }

    func testDroppingEvents() {
        // TODO: needs proper implementation of AttributesWithCapacity

//        let maxNumberOfEvents = 8
//        let traceConfig = TraceConfig().settingMaxNumberOfEvents(maxNumberOfEvents)
//        let span = createTestSpan(config: traceConfig)
//        for _ in 0 ..< 2 * maxNumberOfEvents {
//            span.addEvent(event: event)
//            testClock.advanceMillis(millis: millisPerSecond)
//        }
//        var spanData = span.toSpanData()
//        XCTAssertEqual(spanData.timedEvents?.count, maxNumberOfEvents)
//
//        for i in 0 ..< maxNumberOfEvents {
//            let expectedEvent = TimedEvent( nanotime: Timestamp(fromSeconds: startTime.getSeconds() + maxNumberOfEvents + i, nanoseconds: 0).getNanos(), event: event)
//            XCTAssertEqual(spanData.timedEvents?[i], expectedEvent)
//        }
//        span.end()
//        spanData = span.toSpanData()
//        XCTAssertEqual(spanData.timedEvents?.count, maxNumberOfEvents)
//        for i in 0 ..< maxNumberOfEvents {
//            let expectedEvent = TimedEvent( nanotime: Timestamp(fromSeconds: startTime.getSeconds() + maxNumberOfEvents + i, nanoseconds: 0).getNanos(), event: event)
//            XCTAssertEqual(spanData.timedEvents?[i], expectedEvent)
//        }
    }

    func testAsSpanData() {
        let name = "GreatSpan"
        let kind = SpanKind.server
        let traceId = TraceId.random()
        let spanId = SpanId.random()
        let parentSpanId = SpanId.random()
        let traceConfig = TraceConfig()
        let spanProcessor = NoopSpanProcessor()
        let clock = TestClock()
        var labels = [String: String]()
        labels["foo"] = "bar"
        let resource = Resource(labels: labels)
        let attributes = TestUtils.generateRandomAttributes()
        let event1Attributes = TestUtils.generateRandomAttributes()
        let event2Attributes = TestUtils.generateRandomAttributes()
        let context = SpanContext(traceId: traceId, spanId: spanId, traceFlags: TraceFlags(), tracestate: Tracestate())
        let link1 = SimpleLink(context: context, attributes: TestUtils.generateRandomAttributes())
        let links = [link1]

        let readableSpan = RecordEventsReadableSpan.startSpan(context: context, name: name, kind: kind, parentSpanId: parentSpanId, traceConfig: traceConfig, spanProcessor: spanProcessor, timestampConverter: nil, clock: clock, resource: resource, attributes: attributes, links: links, totalRecordedLinks: 1)
        let startTimeNanos = clock.nowNanos
        clock.advanceMillis(millis: 4)
        let firstEventTimeNanos = clock.nowNanos
        readableSpan.addEvent(name: "event1", attributes: event1Attributes)
        clock.advanceMillis(millis: 6)
        let secondEventTimeNanos = clock.nowNanos
        readableSpan.addEvent(name: "event2", attributes: event2Attributes)

        clock.advanceMillis(millis: 100)
        readableSpan.end()
        let endTimeNanos = clock.nowNanos
        let timedEvent1 = TimedEvent(nanotime: firstEventTimeNanos, event: SimpleEvent(name: "event1", attributes: event1Attributes))
        let timedEvent2 = TimedEvent(nanotime: secondEventTimeNanos, event: SimpleEvent(name: "event2", attributes: event2Attributes))
        let timedEvents = [timedEvent1, timedEvent2]
        let expected = SpanData(traceId: traceId, spanId: spanId, traceFlags: TraceFlags(), tracestate: Tracestate(), parentSpanId: parentSpanId, resource: resource, name: name, kind: kind, timestamp: nanoToTimestamp(nanotime: startTimeNanos), attributes: attributes, timedEvents: timedEvents, links: links, status: .ok, endTimestamp: nanoToTimestamp(nanotime: endTimeNanos))

        let result = readableSpan.toSpanData()
        XCTAssertEqual(expected, result)
    }

    private func createTestRootSpan() -> RecordEventsReadableSpan {
        return createTestSpan(kind: .internal, config: TraceConfig(), parentSpanId: nil, attributes: [String: AttributeValue]())
    }

    private func createTestSpan(attributes: [String: AttributeValue]) -> RecordEventsReadableSpan {
        return createTestSpan(kind: .internal, config: TraceConfig(), parentSpanId: nil, attributes: attributes)
    }

    private func createTestSpan(kind: SpanKind) -> RecordEventsReadableSpan {
        return createTestSpan(kind: kind, config: TraceConfig(), parentSpanId: parentSpanId, attributes: [String: AttributeValue]())
    }

    private func createTestSpan(config: TraceConfig) -> RecordEventsReadableSpan {
        return createTestSpan(kind: .internal, config: config, parentSpanId: nil, attributes: [String: AttributeValue]())
    }

    private func createTestSpan(kind: SpanKind, config: TraceConfig, parentSpanId: SpanId?, attributes: [String: AttributeValue]) -> RecordEventsReadableSpan {
        let span = RecordEventsReadableSpan.startSpan(context: spanContext, name: spanName, kind: kind, parentSpanId: parentSpanId, traceConfig: config, spanProcessor: spanProcessor, timestampConverter: timestampConverter, clock: testClock, resource: resource, attributes: attributes, links: [link], totalRecordedLinks: 1)
        XCTAssertEqual(spanProcessor.onStartCalledTimes, 1)
        return span
    }

    private func spanDoWork(span: RecordEventsReadableSpan, status: Status?) {
        span.setAttribute(key: "MySingleStringAttributeKey", value: AttributeValue.string("MySingleStringAttributeValue"))

        for attribute in attributes {
            span.setAttribute(key: attribute.key, value: attribute.value)
        }
        testClock.advanceMillis(millis: millisPerSecond)
        span.addEvent(event: event)
        testClock.advanceMillis(millis: millisPerSecond)
        span.addChild()
        span.updateName(name: spanNewName)
        span.status = status
    }

    private func verifySpanData(spanData: SpanData, attributes: [String: AttributeValue], timedEvents: [TimedEvent], links: [Link], spanName: String, startTime: Timestamp, endTime: Timestamp, status: Status) {
        XCTAssertEqual(spanData.traceId, traceId)
        XCTAssertEqual(spanData.spanId, spanId)
        XCTAssertEqual(spanData.parentSpanId, parentSpanId)
        XCTAssertEqual(spanData.tracestate, Tracestate())
        XCTAssertEqual(spanData.resource, resource)
        XCTAssertEqual(spanData.name, spanName)
        XCTAssertEqual(spanData.attributes, attributes)
        XCTAssertEqual(spanData.timedEvents, timedEvents)
        XCTAssert(spanData.links == links)
        XCTAssertEqual(spanData.timestamp, startTime)
        XCTAssertEqual(spanData.endTimestamp, endTime)
        XCTAssertEqual(spanData.status?.canonicalCode, status.canonicalCode)
    }

    private func nanoToTimestamp(nanotime: Int) -> Timestamp {
        return Timestamp(fromSeconds: nanotime / nanosPerSecond, nanoseconds: nanotime % nanosPerSecond)
    }
}
