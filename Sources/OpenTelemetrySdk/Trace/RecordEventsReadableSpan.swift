//
//  RecordEventsReadableSpan.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 05/11/2019.
//

import Foundation
import OpenTelemetryApi

// TODO: needs proper implementation of AttributesWithCapacity
typealias EvictingQueue = [TimedEvent]
// TODO: needs proper implementation of AttributesWithCapacity
typealias AttributesWithCapacity = [String: AttributeValue]

class RecordEventsReadableSpan: ReadableSpan {
//    private static final Logger logger = Logger.getLogger(Tracer.class.getName());

    var isRecordingEvents = true

    // Contains the identifiers associated with this Span.
    private(set) var context: SpanContext
    // The parent SpanId of this span. Invalid if this is a root span.
    private(set) var parentSpanId: SpanId?
    // True if the parent is on a different process.
    private(set) var hasRemoteParent: Bool
    // Handler called when the span starts and ends.
    private(set) var spanProcessor: SpanProcessor
    // The displayed name of the span.
    // List of recorded links to parent and child spans.
    private(set) var links = [Link]()
    // Number of links recorded.
    private(set) var totalRecordedLinks: Int

    private(set) var name: String
    // The kind of the span.
    private(set) var kind: SpanKind
    // The clock used to get the time.
    private(set) var clock: Clock
    // The resource associated with this span.
    private(set) var resource: Resource
    // The start time of the span.
    // instrumentation library of the named tracer which created this span
    private(set) var instrumentationLibraryInfo: InstrumentationLibraryInfo
    // The resource associated with this span.
    private(set) var startEpochNanos: Int
    // Set of recorded attributes. DO NOT CALL any other method that changes the ordering of events.
    private(set) var attributes = AttributesWithCapacity()
    // List of recorded events.
    private(set) var events = EvictingQueue()
    // Number of events recorded.
    private(set) var totalRecordedEvents = 0
    // The number of children.
    private(set) var numberOfChildren: Int
    // The status of the span.
    var status: Status? = Status.ok {
        didSet {
            if hasBeenEnded || status == nil {
                status = oldValue
            }
        }
    }
    // The end time of the span.
    private var endEpochNanos: Int?

    // True if the span is ended.
    private(set) var hasBeenEnded: Bool

    private init(context: SpanContext, name: String, instrumentationLibraryInfo: InstrumentationLibraryInfo, kind: SpanKind, parentSpanId: SpanId?, hasRemoteParent: Bool, spanProcessor: SpanProcessor, clock: Clock, resource: Resource, attributes: [String: AttributeValue], links: [Link], totalRecordedLinks: Int, startEpochNanos: Int) {
        self.context = context
        self.name = name
        self.instrumentationLibraryInfo = instrumentationLibraryInfo
        self.parentSpanId = parentSpanId
        self.hasRemoteParent = hasRemoteParent
        self.links = links
        self.totalRecordedLinks = totalRecordedLinks
        self.kind = kind
        self.spanProcessor = spanProcessor
        self.clock = clock
        self.resource = resource
        hasBeenEnded = false
        numberOfChildren = 0
        self.startEpochNanos = (startEpochNanos == 0 ? clock.now : startEpochNanos)
        self.attributes = attributes
    }

    /**
     * Creates and starts a span with the given configuration.
     *
     * @param context supplies the trace_id and span_id for the newly started span.
     * @param name the displayed name for the new span.
     * @param kind the span kind.
     * @param parentSpanId the span_id of the parent span, or null if the new span is a root span.
     * @param hasRemoteParent {@code true} if the parentContext is remote. {@code false} if this is a
     *     root span.
     * @param traceConfig trace parameters like sampler and probability.
     * @param spanProcessor handler called when the span starts and ends.
     * @param clock the clock used to get the time.
     * @param resource the resource associated with this span.
     * @param attributes the attributes set during span creation.
     * @param links the links set during span creation, may be truncated.
     * @param totalRecordedLinks the total number of links set (including dropped links).
     * @return a new and started span.
     */

    static func startSpan(context: SpanContext, name: String, instrumentationLibraryInfo: InstrumentationLibraryInfo, kind: SpanKind, parentSpanId: SpanId?, hasRemoteParent: Bool, traceConfig: TraceConfig, spanProcessor: SpanProcessor, clock: Clock, resource: Resource, attributes: [String: AttributeValue], links: [Link], totalRecordedLinks: Int, startEpochNanos: Int) -> RecordEventsReadableSpan {
        let span = RecordEventsReadableSpan(context: context, name: name, instrumentationLibraryInfo: instrumentationLibraryInfo, kind: kind, parentSpanId: parentSpanId, hasRemoteParent: hasRemoteParent, spanProcessor: spanProcessor, clock: clock, resource: resource, attributes: attributes, links: links, totalRecordedLinks: totalRecordedLinks, startEpochNanos: startEpochNanos)
        spanProcessor.onStart(span: span)
        return span
    }

    func toSpanData() -> SpanData {
        return SpanData(traceId: context.traceId, spanId: context.spanId, traceFlags: context.traceFlags, tracestate: context.tracestate, parentSpanId: parentSpanId, resource: resource, instrumentationLibraryInfo: instrumentationLibraryInfo, name: name, kind: kind, startEpochNanos: startEpochNanos, attributes: attributes, timedEvents: adaptTimedEvents(), links: adaptLinks(), status: status, endEpochNanos: endEpochNanos ?? clock.now, hasRemoteParent: hasRemoteParent)
    }

    private func adaptTimedEvents() -> [SpanData.TimedEvent] {
        let sourceEvents = getTimedEvents()
        var result = [SpanData.TimedEvent]()
        sourceEvents.forEach {
            result.append(SpanData.TimedEvent(epochNanos: $0.epochNanos, name: $0.name, attributes: $0.attributes))
        }
        return result
    }

    private func adaptLinks() -> [SpanData.Link] {
        var result = [SpanData.Link]()
        links.forEach {
            result.append(SpanData.Link(context: $0.context, attributes: $0.attributes))
        }
        return result
    }

    /**
     * Returns a copy of the timed events for this span.
     *
     * @return The TimedEvents for this span.
     */
    private func getTimedEvents() -> [TimedEvent] {
        return events
    }

    func updateName(name: String) {
        if hasBeenEnded {
            // logger.log(Level.FINE, "Calling updateName() on an ended Span.");
            return
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
        attributes[key] = value
    }

    func addEvent(name: String) {
        addTimedEvent(timedEvent: TimedEvent(nanotime: clock.now, name: name))
    }

    func addEvent(name: String, timestamp: Int) {
        addTimedEvent(timedEvent: TimedEvent(nanotime: timestamp, name: name))
    }

    func addEvent(name: String, attributes: [String: AttributeValue]) {
        addTimedEvent(timedEvent: TimedEvent(nanotime: clock.now, name: name, attributes: attributes))
    }

    func addEvent(name: String, attributes: [String: AttributeValue], timestamp: Int) {
        addTimedEvent(timedEvent: TimedEvent(nanotime: timestamp, name: name, attributes: attributes))
    }

    func addEvent<E>(event: E) where E: Event {
        addTimedEvent(timedEvent: TimedEvent(nanotime: clock.now, event: event))
    }

    func addEvent<E>(event: E, timestamp: Int) where E: Event {
        addTimedEvent(timedEvent: TimedEvent(nanotime: timestamp, event: event))
    }

    private func addTimedEvent(timedEvent: TimedEvent) {
        if hasBeenEnded {
//          logger.log(Level.FINE, "Calling addEvent() on an ended Span.");
            return
        }
        events.append(timedEvent)
        totalRecordedEvents += 1
    }

    func end() {
        endInternal(timestamp: clock.now)
    }

    func end(endOptions: EndSpanOptions) {
        endInternal(timestamp: endOptions.getEndTimestamp() == 0 ? clock.now: endOptions.getEndTimestamp())
    }

    private func endInternal(timestamp: Int) {
        if hasBeenEnded {
            //               logger.log(Level.FINE, "Calling end() on an ended Span.");
            return
        }
        endEpochNanos = timestamp
        hasBeenEnded = true
        spanProcessor.onEnd(span: self)
    }

    func addChild() {
        if hasBeenEnded {
            // logger.log(Level.FINE, "Calling end() on an ended Span.");
            return
        }
        numberOfChildren += 1
    }

    /**
     * Returns the latency of the {@code Span} in nanos. If still active then returns now() - start
     * time.
     *
     * @return the latency of the {@code Span} in nanos.
     */
    func getLatencyNs() -> Int {
        return getEndNanoTimeInternal() - startEpochNanos
    }

    /**
     * Returns the end nano time (see {@link System#nanoTime()}). If the current {@code Span} is not
     * ended then returns {@link Clock#nowNanos()}.
     *
     * @return the end nano time.
     */
    func getEndNanoTime() -> Int {
        return getEndNanoTimeInternal()
    }

    // Use getEndNanoTimeInternal to avoid over-locking.
    private func getEndNanoTimeInternal() -> Int {
        return hasBeenEnded ? endEpochNanos! : clock.now
    }

    private func getStatusWithDefault() -> Status {
        return status ?? Status.ok
    }

    var description: String {
        return "RecordEventsReadableSpan{}"
    }

    // For testing purposes
    internal func getDroppedLinksCount() -> Int {
        return totalRecordedLinks - links.count
    }

    internal func getNumberOfChildren() -> Int {
        return numberOfChildren
    }

    internal func getTotalRecordedEvents() -> Int {
        return totalRecordedEvents
    }
}

// struct AttributesWithCapacity {
//    fileprivate var attributes = [(String, AttributeValue)]()
//    fileprivate var capacity: Int = 0
//
//    init( attributes)
//
//    mutating func setCapacity(capacity: Int) {
//        self.capacity = capacity
//        attributes.reserveCapacity(capacity + 1)
//    }
//
//    subscript(name: String) -> AttributeValue {
//        get {
//            return attributes.first { $0.0 == name }!.1
//        }
//        set(newValue) {
//            attributes.append((name, newValue))
//            if attributes.count > capacity {
//                attributes.removeFirst()
//            }
//        }
//    }
// }
