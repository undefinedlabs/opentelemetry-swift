//
//  SpanData.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 04/11/2019.
//

import Foundation

struct SpanData {
    /**
     * Gets the trace id for this span.
     *
     * @return the trace id.
     */
    private(set) var traceId: TraceId

    /**
     * Gets the span id for this span.
     *
     * @return the span id.
     */
    private(set) var spanId: SpanId

    /**
     * Gets the trace flags for this span.
     *
     * @return the trace flags for this span.
     */
    private(set) var traceFlags: TraceFlags

    /**
     * Gets the Tracestate for this span.
     *
     * @return the Tracestate for this span.
     */
    private(set) var tracestate: Tracestate

    /**
     * Returns the parent {@code SpanId}. If the {@code Span} is a root {@code Span}, the SpanId
     * returned will be invalid..
     *
     * @return the parent {@code SpanId} or an invalid SpanId if this is a root {@code Span}.
     * @since 0.1.0
     */
    private(set) var parentSpanId: SpanId?

    /**
     * Returns the resource of this {@code Span}.
     *
     * @return the resource of this {@code Span}.
     * @since 0.1.0
     */
    private(set) var resource: Resource

    /**
     * Returns the name of this {@code Span}.
     *
     * @return the name of this {@code Span}.
     * @since 0.1.0
     */
    private(set) var name: String

    /**
     * Returns the kind of this {@code Span}.
     *
     * @return the kind of this {@code Span}.
     * @since 0.1.0
     */
    private(set) var kind: SpanKind

    /**
     * Returns the start {@code Timestamp} of this {@code Span}.
     *
     * @return the start {@code Timestamp} of this {@code Span}.
     * @since 0.1.0
     */
    private(set) var timestamp: Timestamp

    /**
     * Returns the attributes recorded for this {@code Span}.
     *
     * @return the attributes recorded for this {@code Span}.
     * @since 0.1.0
     */
    private(set) var attributes: [String: AttributeValue]?

    /**
     * Returns the timed events recorded for this {@code Span}.
     *
     * @return the timed events recorded for this {@code Span}.
     * @since 0.1.0
     */
    private(set) var timedEvents: [TimedEvent]?

    /**
     * Returns links recorded for this {@code Span}.
     *
     * @return links recorded for this {@code Span}.
     * @since 0.1.0
     */
    private(set) var links: [Link]

    /**
     * Returns the {@code Status}.
     *
     * @return the {@code Status}.
     * @since 0.1.0
     */
    private(set) var status: Status?

    /**
     * Returns the end {@code Timestamp}.
     *
     * @return the end {@code Timestamp}.
     * @since 0.1.0
     */
    private(set) var endTimestamp: Timestamp

    mutating func settingName(_ name: String) -> SpanData {
        self.name = name
        return self
    }

    mutating func settingTraceId(_ traceId: TraceId) -> SpanData {
        self.traceId = traceId
        return self
    }

    mutating func settingSpanId(_ spanId: SpanId) -> SpanData {
        self.spanId = spanId
        return self
    }

    mutating func settingTraceFlags(_ traceFlags: TraceFlags) -> SpanData {
        self.traceFlags = traceFlags
        return self
    }

    mutating func settingTracestate(_ tracestate: Tracestate) -> SpanData {
        self.tracestate = tracestate
        return self
    }

    mutating func settingAttributes(_ attributes: [String: AttributeValue]) -> SpanData {
        self.attributes = attributes
        return self
    }

    mutating func settingStartTimestamp(_ startTimestamp: Timestamp) -> SpanData {
        timestamp = startTimestamp
        return self
    }

    mutating func settingEndTimestamp(_ endTimestamp: Timestamp) -> SpanData {
        self.endTimestamp = endTimestamp
        return self
    }

    mutating func settingKind(_ kind: SpanKind) -> SpanData {
        self.kind = kind
        return self
    }

    mutating func settingLinks(_ links: [Link]) -> SpanData {
        self.links = links
        return self
    }

    mutating func settingParentSpanId(_ parentSpanId: SpanId) -> SpanData {
        self.parentSpanId = parentSpanId
        return self
    }

    mutating func settingResource(_ resource: Resource) -> SpanData {
        self.resource = resource
        return self
    }

    mutating func settingStatus(_ status: Status) -> SpanData {
        self.status = status
        return self
    }

    mutating func settingTimedEvents(_ timedEvents: [TimedEvent]) -> SpanData {
        self.timedEvents = timedEvents
        return self
    }

    /**
     * A timed event representation.
     *
     * @since 0.1.0
     */
    //    @Immutable
    //    @AutoValue
    //    public abstract static class TimedEvent {
    //      /**
    //       * Returns a new immutable {@code TimedEvent<T>}.
    //       *
    //       * @param timestamp the {@code Timestamp} of this event.
    //       * @param event the event.
    //       * @return a new immutable {@code TimedEvent<T>}
    //       * @since 0.1.0
    //       */
    //      public static TimedEvent create(Timestamp timestamp, io.opentelemetry.trace.Event event) {
    //        return new AutoValue_SpanData_TimedEvent(timestamp, event.getName(), event.getAttributes());
    //      }
    //
    //      /**
    //       * Returns the {@code Timestamp} of this event.
    //       *
    //       * @return the {@code Timestamp} of this event.
    //       * @since 0.1.0
    //       */
    //      public abstract Timestamp getTimestamp();
    //
    //      /**
    //       * Returns the name of this event.
    //       *
    //       * @return the name of this event.
    //       */
    //      public abstract String getName();
    //
    //      /**
    //       * Gets the attributes for this event.
    //       *
    //       * @return the attributes for this event.
    //       */
    //      public abstract Map<String, AttributeValue> getAttributes();
    //
    //      TimedEvent() {}
}
