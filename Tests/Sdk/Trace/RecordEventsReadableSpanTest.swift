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
    let resource = Resource.empty()
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
        XCTAssertEqual(spanData.attributes?.count, attributes.count)
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
        XCTAssertEqual(spanData.attributes?.count, 4)
    }

    func testAddEvent() {
        let span = createTestRootSpan()
        span.addEvent(name: "event1")
        span.addEvent(name: "event2", attributes: attributes)
        span.addEvent(event: SimpleEvent(name: "event3"))
        span.end()
        let spanData = span.toSpanData()
        XCTAssertEqual(spanData.timedEvents?.count, 3)
    }


//      func testDroppingAttributes() {
//        let maxNumberOfAttributes = 8;
//        let traceConfig = TraceConfig().settingMaxNumberOfAttributes(maxNumberOfAttributes)
//        let span = createTestSpan(config: traceConfig)
//
//        for i in 0..<(2 * maxNumberOfAttributes) {
//            span.setAttribute(key: "MyStringAttributeKey\(i)", value: AttributeValue.int(i));
//          }
//          var spanData = span.toSpanData()
//        XCTAssertEqual(spanData.attributes?.count, maxNumberOfAttributes)
//
//          for i in 0..<maxNumberOfAttributes  {
//            let expectedValue = AttributeValue.int(i + maxNumberOfAttributes);
//            XCTAssertEqual(spanData.attributes?["MyStringAttributeKey\(i + maxNumberOfAttributes)"], expectedValue)
//          }
//          span.end();
//        spanData = span.toSpanData()
//        XCTAssertEqual(spanData.attributes?.count, maxNumberOfAttributes)
//
//        for i in 0..<maxNumberOfAttributes {
//          let expectedValue = AttributeValue.int(i + maxNumberOfAttributes);
//          XCTAssertEqual(spanData.attributes?["MyStringAttributeKey\(i + maxNumberOfAttributes)"], expectedValue)
//        }
//      }
//
//      func test droppingAndAddingAttributes() {
//        final int maxNumberOfAttributes = 8;
//        TraceConfig traceConfig =
//            TraceConfig.getDefault()
//                .toBuilder()
//                .setMaxNumberOfAttributes(maxNumberOfAttributes)
//                .build();
//        let span = createTestSpan(config: traceConfig)
//        try {
//          for (int i = 0; i < 2 * maxNumberOfAttributes; i++) {
//            span.setAttribute("MyStringAttributeKey" + i, AttributeValue.longAttributeValue(i));
//          }
//          let spanData = span.toSpanData()
//          assertThat(spanData.getAttributes().size()).isEqualTo(maxNumberOfAttributes);
//          for (int i = 0; i < maxNumberOfAttributes; i++) {
//            AttributeValue expectedValue = AttributeValue.longAttributeValue(i + maxNumberOfAttributes);
//            assertThat(
//                    spanData.getAttributes().get("MyStringAttributeKey" + (i + maxNumberOfAttributes)))
//                .isEqualTo(expectedValue);
//          }
//
//          for (int i = 0; i < maxNumberOfAttributes / 2; i++) {
//            span.setAttribute("MyStringAttributeKey" + i, AttributeValue.longAttributeValue(i));
//          }
//          spanData = span.toSpanData();
//          assertThat(spanData.getAttributes().size()).isEqualTo(maxNumberOfAttributes);
//          // Test that we still have in the attributes map the latest maxNumberOfAttributes / 2 entries.
//          for (int i = 0; i < maxNumberOfAttributes / 2; i++) {
//            int val = i + maxNumberOfAttributes * 3 / 2;
//            AttributeValue expectedValue = AttributeValue.longAttributeValue(val);
//            assertThat(spanData.getAttributes().get("MyStringAttributeKey" + val))
//                .isEqualTo(expectedValue);
//          }
//          // Test that we have the newest re-added initial entries.
//          for (int i = 0; i < maxNumberOfAttributes / 2; i++) {
//            AttributeValue expectedValue = AttributeValue.longAttributeValue(i);
//            assertThat(spanData.getAttributes().get("MyStringAttributeKey" + i))
//                .isEqualTo(expectedValue);
//          }
//        } finally {
//          span.end();
//        }
//      }
//
//      func test droppingEvents() {
//        final int maxNumberOfEvents = 8;
//        TraceConfig traceConfig =
//            TraceConfig.getDefault().toBuilder().setMaxNumberOfEvents(maxNumberOfEvents).build();
//        let span = createTestSpan(config: traceConfig)
//        try {
//          for (int i = 0; i < 2 * maxNumberOfEvents; i++) {
//            span.addEvent(event);
//            testClock.advanceMillis(MILLIS_PER_SECOND);
//          }
//          let spanData = span.toSpanData()
//
//          assertThat(spanData.getTimedEvents().size()).isEqualTo(maxNumberOfEvents);
//          for (int i = 0; i < maxNumberOfEvents; i++) {
//            SpanData.TimedEvent expectedEvent =
//                SpanData.TimedEvent.create(
//                    Timestamp.create(startTime.getSeconds() + maxNumberOfEvents + i, 0), event);
//            assertThat(spanData.getTimedEvents().get(i)).isEqualTo(expectedEvent);
//          }
//        } finally {
//          span.end();
//        }
//        let spanData = span.toSpanData()
//        assertThat(spanData.getTimedEvents().size()).isEqualTo(maxNumberOfEvents);
//        for (int i = 0; i < maxNumberOfEvents; i++) {
//          SpanData.TimedEvent expectedEvent =
//              SpanData.TimedEvent.create(
//                  Timestamp.create(startTime.getSeconds() + maxNumberOfEvents + i, 0), event);
//          assertThat(spanData.getTimedEvents().get(i)).isEqualTo(expectedEvent);
//        }
//      }
//

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
        XCTAssertTrue(spanData.links.elementsEqual(links) { $0.context == $1.context && $0.attributes == $1.attributes })
        XCTAssertEqual(spanData.timestamp, startTime)
        XCTAssertEqual(spanData.endTimestamp, endTime)
        XCTAssertEqual(spanData.status?.canonicalCode, status.canonicalCode)
    }

//
//      private static final class SimpleEvent implements Event {
//
//        private final String name;
//        private final Map<String, AttributeValue> attributes;
//
//        private SimpleEvent(String name, Map<String, AttributeValue> attributes) {
//          this.name = name;
//          this.attributes = attributes;
//        }
//
//        @Override
//        public String getName() {
//          return name;
//        }
//
//        @Override
//        public Map<String, AttributeValue> getAttributes() {
//          return attributes;
//        }
//      }
//
//      func test testAsSpanData() {
//        String name = "GreatSpan";
//        Kind kind = Kind.SERVER;
//        TraceId traceId = TestUtils.generateRandomTraceId();
//        SpanId spanId = TestUtils.generateRandomSpanId();
//        SpanId parentSpanId = TestUtils.generateRandomSpanId();
//        TraceConfig traceConfig = TraceConfig.getDefault();
//        SpanProcessor spanProcessor = NoopSpanProcessor.getInstance();
//        TestClock clock = TestClock.create();
//        Map<String, String> labels = new HashMap<>();
//        labels.put("foo", "bar");
//        Resource resource = Resource.create(labels);
//        Map<String, AttributeValue> attributes = TestUtils.generateRandomAttributes();
//        Map<String, AttributeValue> event1Attributes = TestUtils.generateRandomAttributes();
//        Map<String, AttributeValue> event2Attributes = TestUtils.generateRandomAttributes();
//        SpanContext context =
//            SpanContext.create(traceId, spanId, TraceFlags.getDefault(), Tracestate.getDefault());
//        Link link1 =
//            io.opentelemetry.trace.util.Links.create(context, TestUtils.generateRandomAttributes());
//        List<Link> links = Collections.singletonList(link1);
//
//        RecordEventsReadableSpan readableSpan =
//            RecordEventsReadableSpan.startSpan(
//                context,
//                name,
//                kind,
//                parentSpanId,
//                traceConfig,
//                spanProcessor,
//                null,
//                clock,
//                resource,
//                attributes,
//                links,
//                1);
//        long startTimeNanos = clock.nowNanos();
//        clock.advanceMillis(4);
//        long firstEventTimeNanos = clock.nowNanos();
//        readableSpan.addEvent("event1", event1Attributes);
//        clock.advanceMillis(6);
//        long secondEventTimeNanos = clock.nowNanos();
//        readableSpan.addEvent("event2", event2Attributes);
//
//        clock.advanceMillis(100);
//        readableSpan.end();
//        long endTimeNanos = clock.nowNanos();
//
//        SpanData expected =
//            SpanData.newBuilder()
//                .setName(name)
//                .setKind(kind)
//                .setStatus(Status.OK)
//                .setStartTimestamp(nanoToTimestamp(startTimeNanos))
//                .setEndTimestamp(nanoToTimestamp(endTimeNanos))
//                .setTimedEvents(
//                    Arrays.asList(
//                        SpanData.TimedEvent.create(
//                            nanoToTimestamp(firstEventTimeNanos),
//                            Events.create("event1", event1Attributes)),
//                        SpanData.TimedEvent.create(
//                            nanoToTimestamp(secondEventTimeNanos),
//                            Events.create("event2", event2Attributes))))
//                .setResource(resource)
//                .setParentSpanId(parentSpanId)
//                .setLinks(links)
//                .setTraceId(traceId)
//                .setSpanId(spanId)
//                .setAttributes(attributes)
//                .build();
//
//        SpanData result = readableSpan.toSpanData();
//        assertEquals(expected, result);
//      }
//
//      private static Timestamp nanoToTimestamp(long nanotime) {
//        return Timestamp.create(nanotime / NANOS_PER_SECOND, (int) (nanotime % NANOS_PER_SECOND));
//      }
//    }
}
