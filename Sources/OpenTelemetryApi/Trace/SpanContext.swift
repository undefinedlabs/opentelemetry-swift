//
//  SpanContext.swift
//
//
//  Created by Ignacio Bonafonte on 14/10/2019.
//

import Foundation

/// A class that represents a span context. A span context contains the state that must propagate to
/// child Spans and across process boundaries. It contains the identifiers race_id and span_id
/// associated with the Span and a set of options.
public final class SpanContext: Equatable, CustomStringConvertible {
    /// The trace identifier associated with this SpanContext
    public private(set) var traceId: TraceId

    /// The span identifier associated with this  SpanContext
    public private(set) var spanId: SpanId

    /// The traceFlags associated with this SpanContext
    public private(set) var traceFlags: TraceFlags

    /// The tracestate associated with this SpanContext
    public let tracestate: Tracestate

    /// The tracestate associated with this SpanContext
    public let isRemote: Bool

    /// The invalid {@code SpanContext} that can be used for no-op operations.
    public static let invalid = SpanContext(traceId: TraceId.invalid, spanId: SpanId.invalid, traceFlags: TraceFlags(), tracestate: Tracestate(), isRemote: false)

    private init(traceId: TraceId, spanId: SpanId, traceFlags: TraceFlags, tracestate: Tracestate, isRemote: Bool) {
        self.traceId = traceId
        self.spanId = spanId
        self.traceFlags = traceFlags
        self.tracestate = tracestate
        self.isRemote = isRemote
    }

    /// Creates a new SpanContext with the given identifiers and options.
    /// - Parameters:
    ///   - traceId: the trace identifier of the span context.
    ///   - spanId: the span identifier of the span context.
    ///   - traceFlags: he trace options for the span context.
    ///   - tracestate: the trace state for the span context.
    public static func create(traceId: TraceId, spanId: SpanId, traceFlags: TraceFlags, tracestate: Tracestate) -> SpanContext {
        return SpanContext(traceId: traceId, spanId: spanId, traceFlags: traceFlags, tracestate: tracestate, isRemote: false)
    }

    /// Creates a new SpanContext that was propagated from a remote parent, with the given
    /// identifiers and options.

    /// - Parameters:
    ///   - traceId: the trace identifier of the span context.
    ///   - spanId: the span identifier of the span context.
    ///   - traceFlags: he trace options for the span context.
    ///   - tracestate: the trace state for the span context.
    public static func createFromRemoteParent(traceId: TraceId, spanId: SpanId, traceFlags: TraceFlags, tracestate: Tracestate) -> SpanContext {
        return SpanContext(traceId: traceId, spanId: spanId, traceFlags: traceFlags, tracestate: tracestate, isRemote: true)
    }

    /// Returns true if this SpanContext} is valid.
    public var isValid: Bool {
        return traceId.isValid && spanId.isValid
    }

    public static func == (lhs: SpanContext, rhs: SpanContext) -> Bool {
        return lhs.traceId == rhs.traceId && lhs.spanId == rhs.spanId && lhs.traceFlags == rhs.traceFlags && lhs.isRemote == rhs.isRemote
    }

    public var description: String {
        return "SpanContext{traceId=\(traceId), spanId=\(spanId), traceFlags=\(traceFlags)}, isRemote=\(isRemote)"
    }
}
