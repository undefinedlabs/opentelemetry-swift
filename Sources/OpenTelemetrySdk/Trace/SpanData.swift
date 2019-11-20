//
//  SpanData.swift
//  Created by Ignacio Bonafonte on 04/11/2019.
//

import Foundation
import OpenTelemetryApi

public struct SpanData: Equatable {

    public struct TimedEvent: Event, Equatable {
        public var epochNanos: Int
        public var name: String
        public var attributes: [String : AttributeValue]
    }

    public class Link: OpenTelemetryApi.Link {
        public var context: SpanContext
        public var attributes: [String : AttributeValue]

        init(context: SpanContext, attributes: [String : AttributeValue] = [String : AttributeValue]()) {
            self.context = context
            self.attributes = attributes
        }
    }

    /**
     * Gets the trace id for this span.
     *
     * @return the trace id.
     */
    public private(set) var traceId: TraceId

    /**
     * Gets the span id for this span.
     *
     * @return the span id.
     */
    public private(set) var spanId: SpanId

    /**
     * Gets the trace flags for this span.
     *
     * @return the trace flags for this span.
     */
    public private(set) var traceFlags: TraceFlags

    /**
     * Gets the Tracestate for this span.
     *
     * @return the Tracestate for this span.
     */
    public private(set) var tracestate: Tracestate

    /**
     * Returns the parent {@code SpanId}. If the {@code Span} is a root {@code Span}, the SpanId
     * returned will be invalid..
     *
     * @return the parent {@code SpanId} or an invalid SpanId if this is a root {@code Span}.
     * @since 0.1.0
     */
    public private(set) var parentSpanId: SpanId?

    /**
     * Returns the resource of this {@code Span}.
     *
     * @return the resource of this {@code Span}.
     * @since 0.1.0
     */
    public private(set) var resource: Resource

    /**
     * Returns the instrumentation library specified when creating the tracer which produced this
      * {@code Span}.
      *
      * @return an instance of {@link InstrumentationLibraryInfo}
      */
    public private(set) var instrumentationLibraryInfo: InstrumentationLibraryInfo

    /**
     * Returns the name of this {@code Span}.
     *
     * @return the name of this {@code Span}.
     * @since 0.1.0
     */
    public private(set) var name: String

    /**
     * Returns the kind of this {@code Span}.
     *
     * @return the kind of this {@code Span}.
     * @since 0.1.0
     */
    public private(set) var kind: SpanKind

    /**
     * Returns the start epoch timestamp in nanos of this {@code Span}.
     *
     * @return the start epoch timestamp in nanos of this {@code Span}.
     * @since 0.1.0
     */
    public private(set) var startEpochNanos: Int

    /**
     * Returns the attributes recorded for this {@code Span}.
     *
     * @return the attributes recorded for this {@code Span}.
     * @since 0.1.0
     */
    public private(set) var attributes = [String: AttributeValue]()

    /**
     * Returns the timed events recorded for this {@code Span}.
     *
     * @return the timed events recorded for this {@code Span}.
     * @since 0.1.0
     */
    public private(set) var timedEvents = [TimedEvent]()

    /**
     * Returns links recorded for this {@code Span}.
     *
     * @return links recorded for this {@code Span}.
     * @since 0.1.0
     */
    public private(set) var links = [Link]()

    /**
     * Returns the {@code Status}.
     *
     * @return the {@code Status}.
     * @since 0.1.0
     */
    public private(set) var status: Status?

    /**
     * Returns the end {@code Timestamp}.
     *
     * @return the end {@code Timestamp}.
     * @since 0.1.0
     */
    public private(set) var endEpochNanos: Int

    /**
     * Returns {@code true} if the parent is on a different process. {@code false} if this is a root
     * span.
     *
     * @return {@code true} if the parent is on a different process. {@code false} if this is a root
     *     span.
     * @since 0.3.0
     */
    public private(set) var hasRemoteParent: Bool;

    public static func == (lhs: SpanData, rhs: SpanData) -> Bool {
        return lhs.traceId == rhs.traceId &&
            lhs.spanId == rhs.spanId &&
            lhs.traceFlags == rhs.traceFlags &&
            lhs.tracestate == rhs.tracestate &&
            lhs.parentSpanId == rhs.parentSpanId &&
            lhs.name == rhs.name &&
            lhs.kind == rhs.kind &&
            lhs.status == rhs.status &&
            lhs.endEpochNanos == rhs.endEpochNanos &&
            lhs.startEpochNanos == rhs.startEpochNanos &&
            lhs.hasRemoteParent == rhs.hasRemoteParent &&
            lhs.resource == rhs.resource &&
            lhs.attributes == rhs.attributes &&
            lhs.timedEvents == rhs.timedEvents &&
            lhs.links == rhs.links
    }

    public mutating func settingName(_ name: String) -> SpanData {
        self.name = name
        return self
    }

    public mutating func settingTraceId(_ traceId: TraceId) -> SpanData {
        self.traceId = traceId
        return self
    }

    public mutating func settingSpanId(_ spanId: SpanId) -> SpanData {
        self.spanId = spanId
        return self
    }

    public mutating func settingTraceFlags(_ traceFlags: TraceFlags) -> SpanData {
        self.traceFlags = traceFlags
        return self
    }

    public mutating func settingTracestate(_ tracestate: Tracestate) -> SpanData {
        self.tracestate = tracestate
        return self
    }

    public mutating func settingAttributes(_ attributes: [String: AttributeValue]) -> SpanData {
        self.attributes = attributes
        return self
    }

    public mutating func settingStartEpochNanos(_ nanos: Int) -> SpanData {
        self.startEpochNanos = nanos
        return self
    }

    public mutating func settingEndEpochNanos(_ nanos: Int) -> SpanData {
        self.endEpochNanos = nanos
        return self
    }

    public mutating func settingKind(_ kind: SpanKind) -> SpanData {
        self.kind = kind
        return self
    }

    public mutating func settingLinks(_ links: [Link]) -> SpanData {
        self.links = links
        return self
    }

    public mutating func settingParentSpanId(_ parentSpanId: SpanId) -> SpanData {
        self.parentSpanId = parentSpanId
        return self
    }

    public mutating func settingResource(_ resource: Resource) -> SpanData {
        self.resource = resource
        return self
    }

    public mutating func settingStatus(_ status: Status) -> SpanData {
        self.status = status
        return self
    }

    public mutating func settingTimedEvents(_ timedEvents: [TimedEvent]) -> SpanData {
        self.timedEvents = timedEvents
        return self
    }

    public mutating func settingHasRemoteParent(_ hasRemoteParent: Bool) -> SpanData {
        self.hasRemoteParent = hasRemoteParent
        return self
    }
}
