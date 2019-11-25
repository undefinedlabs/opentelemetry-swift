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

import Foundation
import OpenTelemetryApi

/// representation of all data collected by the Span.
public struct SpanData: Equatable {
    public struct TimedEvent: Event, Equatable {
        public var epochNanos: Int
        public var name: String
        public var attributes: [String: AttributeValue]
    }

    public class Link: OpenTelemetryApi.Link {
        public var context: SpanContext
        public var attributes: [String: AttributeValue]

        init(context: SpanContext, attributes: [String: AttributeValue] = [String: AttributeValue]()) {
            self.context = context
            self.attributes = attributes
        }
    }

    /// The trace id for this span.
    public private(set) var traceId: TraceId

    /// The span id for this span.
    public private(set) var spanId: SpanId

    /// The trace flags for this span.
    public private(set) var traceFlags: TraceFlags

    /// The Tracestate for this span.
    public private(set) var tracestate: Tracestate

    /// The parent SpanId. If the  Span is a root Span, the SpanId
    /// returned will be nil.
    public private(set) var parentSpanId: SpanId?

    /// The resource of this Span.
    public private(set) var resource: Resource

    /// The instrumentation library specified when creating the tracer which produced this Span
    public private(set) var instrumentationLibraryInfo: InstrumentationLibraryInfo

    /// The name of this Span.
    public private(set) var name: String

    /// The kind of this Span.
    public private(set) var kind: SpanKind

    /// The start epoch timestamp in nanos of this Span.
    public private(set) var startEpochNanos: Int

    /// The attributes recorded for this Span.
    public private(set) var attributes = [String: AttributeValue]()

    /// The timed events recorded for this Span.
    public private(set) var timedEvents = [TimedEvent]()

    /// The links recorded for this Span.
    public private(set) var links = [Link]()

    /// The Status.
    public private(set) var status: Status?

    /// The end epoch timestamp in nanos of this Span
    public private(set) var endEpochNanos: Int

    /// True if the parent is on a different process, false if this is a root span.
    public private(set) var hasRemoteParent: Bool

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
        startEpochNanos = nanos
        return self
    }

    public mutating func settingEndEpochNanos(_ nanos: Int) -> SpanData {
        endEpochNanos = nanos
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
