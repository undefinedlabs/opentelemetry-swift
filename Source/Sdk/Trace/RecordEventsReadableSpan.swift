//
//  RecordEventsReadableSpan.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 05/11/2019.
//

import Foundation

typealias AttributesWithCapacity = [String: AttributeValue]
typealias EvictingQueue = [TimedEvent]

class RecordEventsReadableSpan: ReadableSpan {

    var IsRecordingEvents = true

    // Contains the identifiers associated with this Span.
    private(set) var context: SpanContext
    // The parent SpanId of this span. Invalid if this is a root span.
    private(set) var parentSpanId: SpanId?
    // Active trace configs when the Span was created.
    private(set) var traceConfig: TraceConfig
    // Handler called when the span starts and ends.
    private(set) var spanProcessor: SpanProcessor
    // The displayed name of the span.
    // List of recorded links to parent and child spans.
    private(set) var links: [Link]
    // Number of links recorded.
    private(set) var totalRecordedLinks: Int

    private(set) var name: String
    // The kind of the span.
    private(set) var kind: SpanKind
    // The clock used to get the time.
    private(set) var clock: Clock
    // The time converter used to convert nano time to Timestamp. This is needed because Java has
    // millisecond granularity for Timestamp and tracing events are recorded more often.
    private(set) var timestampConverter: TimestampConverter
    // The resource associated with this span.
    private(set) var resource: Resource
    // The start time of the span.
    private(set) var startNanoTime: Int
    // Set of recorded attributes. DO NOT CALL any other method that changes the ordering of events.
//    var attributes: AttributesWithCapacity?
    private(set) var attributes: AttributesWithCapacity?
    // List of recorded events.
    private(set) var events: EvictingQueue?
    // Number of events recorded.
    private(set) var totalRecordedEvents = 0
    // The number of children.
    private(set) var numberOfChildren: Int
    // The status of the span.
    var status: Status?
    // The end time of the span.
    private(set) var endNanoTime: Int?
    // True if the span is ended.
    private(set) var hasBeenEnded: Bool

    private init(context: SpanContext, name: String, kind: SpanKind, parentSpanId: SpanId?, traceConfig: TraceConfig, spanProcessor: SpanProcessor, timestampConverter: TimestampConverter?, clock: Clock, resource: Resource, attributes: [String: AttributeValue], links: [Link], totalRecordedLinks: Int) {
        self.context = context
        self.parentSpanId = parentSpanId
        self.links = links
        self.totalRecordedLinks = totalRecordedLinks
        self.name = name
        self.kind = kind
        self.traceConfig = traceConfig
        self.spanProcessor = spanProcessor
        self.clock = clock
        self.resource = resource
        hasBeenEnded = false
        numberOfChildren = 0
        self.timestampConverter = timestampConverter ?? TimestampConverter.now(clock: clock)
        startNanoTime = clock.nowNanos
    }

    static func startSpan(context: SpanContext, name: String, kind: SpanKind, parentSpanId: SpanId?, traceConfig: TraceConfig, spanProcessor: SpanProcessor, timestampConverter: TimestampConverter?, clock: Clock, resource: Resource, attributes: [String: AttributeValue], links: [Link], totalRecordedLinks: Int) -> RecordEventsReadableSpan {
        let span = RecordEventsReadableSpan(context: context, name: name, kind: kind, parentSpanId: parentSpanId, traceConfig: traceConfig, spanProcessor: spanProcessor, timestampConverter: timestampConverter, clock: clock, resource: resource, attributes: attributes, links: links, totalRecordedLinks: totalRecordedLinks)
        spanProcessor.onStart(span: span)
        return span
    }

    func toSpanData() -> SpanData {
        let startTimestamp = timestampConverter.convertNanoTime(nanoTime: startNanoTime)
        let endTimestamp = timestampConverter.convertNanoTime(nanoTime: endNanoTime ?? startNanoTime)

        return SpanData(traceId: context.traceId, spanId: context.spanId, traceFlags: context.traceFlags, tracestate: context.tracestate, parentSpanId: parentSpanId, resource: resource, name: name, kind: kind, timestamp: startTimestamp, attributes: attributes, timedEvents: adaptTimedEvents(), links: links, status: status, endTimestamp: endTimestamp)
    }

//    private mutating func getInitializedAttributes() -> AttributesWithCapacity {
//        if attributes == nil {
    ////            attributes = AttributesWithCapacity(maximumCapacity: traceConfig.maxNumberOfAttributes);
//            attributes = AttributesWithCapacity()
//        }
//        return attributes!
//    }

    private func adaptTimedEvents() -> [TimedEvent] {
        let sourceEvents = getTimedEvents()
        var result = [TimedEvent]()
        _ = sourceEvents.map { result.append(RecordEventsReadableSpan.adaptTimedEvent(sourceEvent: $0, timestampConverter: timestampConverter)) }
        return result
    }

    /**
     * Returns a copy of the timed events for this span.
     *
     * @return The TimedEvents for this span.
     */
    private func getTimedEvents() -> [TimedEvent] {
        return events ?? [TimedEvent]()
    }

    private static func adaptTimedEvent(sourceEvent: TimedEvent, timestampConverter: TimestampConverter) -> TimedEvent {
        let event = SimpleEvent(name: sourceEvent.name, attributes: sourceEvent.attributes)
        return TimedEvent(nanotime: sourceEvent.nanotime, event: event)
    }

    func updateName(name: String) {
        if hasBeenEnded {
            // logger.log(Level.FINE, "Calling updateName() on an ended Span.");
        }
        self.name = name
    }

    func setAttribute(key: String, value: String) {
        setAttribute(key: key, value: AttributeValue.string(value))
    }

    func setAttribute(key: String, value: Int) {
        setAttribute(key: key, value: AttributeValue.int(value))
    }

    func setAttribute(key: String, value: Double) {
        setAttribute(key: key, value: AttributeValue.double(value))
    }

    func setAttribute(key: String, value: Bool) {
        setAttribute(key: key, value: AttributeValue.bool(value))
    }

    func setAttribute(key: String, value: AttributeValue) {
        if hasBeenEnded {
            //               logger.log(Level.FINE, "Calling setAttribute() on an ended Span.");
            return
        }
        attributes = AttributesWithCapacity()
        attributes![key] = value
    }

    func addEvent(name: String) {
        addTimedEvent(timedEvent: TimedEvent(nanotime: clock.nowNanos, name: name))
    }

    func addEvent(name: String, attributes: [String: AttributeValue]) {
        addTimedEvent(timedEvent: TimedEvent(nanotime: clock.nowNanos, name: name, attributes: attributes))
    }

    func addEvent<E>(event: E) where E: Event {
        addTimedEvent(timedEvent: TimedEvent(nanotime: clock.nowNanos, event: event))
    }

    private func addTimedEvent(timedEvent: TimedEvent) {
        if hasBeenEnded {
//          logger.log(Level.FINE, "Calling addEvent() on an ended Span.");
            return
        }
        if events == nil {
            events = [TimedEvent]()
        }
        events!.append(timedEvent)
        totalRecordedEvents += 1
    }

    func end() {
        if hasBeenEnded {
//               logger.log(Level.FINE, "Calling end() on an ended Span.");
            return
        }
        endNanoTime = clock.nowNanos
        hasBeenEnded = true
    }

    func end(timestamp: Timestamp) {
        endNanoTime = timestamp.getNanos()
        hasBeenEnded = true
    }

    func addChild() {
        if hasBeenEnded {
            // logger.log(Level.FINE, "Calling end() on an ended Span.");
            return
        }
        numberOfChildren += 1
    }

    private func getStatusWithDefault() -> Status {
        return status ?? .ok
    }


    var description: String {
        return "RecordEventsReadableSpan{}"
    }

}
