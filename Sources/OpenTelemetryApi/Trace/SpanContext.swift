//
//  SpanContext.swift
//
//
//  Created by Ignacio Bonafonte on 14/10/2019.
//

import Foundation

/**
 * A class that represents a span context. A span context contains the state that must propagate to
 * child {@link Span}s and across process boundaries. It contains the identifiers (a {@link TraceId
 * trace_id} and {@link SpanId span_id}) associated with the {@link Span} and a set of {@link
 * TraceOptions options}.
 *
 * @since 0.1.0
 */
public final class SpanContext: Equatable, CustomStringConvertible {
    static let blank = SpanContext(traceId: TraceId.invalid, spanId: SpanId.invalid, traceFlags: TraceFlags(), tracestate: Tracestate())

    /// The trace identifier associated with this SpanContext
    public private(set) var traceId: TraceId

    /// The span identifier associated with this  SpanContext
    public private(set) var spanId: SpanId

    /// The traceFlags associated with this SpanContext
    public private(set) var traceFlags: TraceFlags

    /// The tracestate associated with this SpanContext
    public let tracestate: Tracestate

    /**
     * Returns the invalid {@code SpanContext} that can be used for no-op operations.
     *
     * @return the invalid {@code SpanContext}.
     */
    static var invalid: SpanContext {
        return blank
    }

    /**
     * Creates a new {@code SpanContext} with the given identifiers and options.
     *
     * @param traceId the trace identifier of the span context.
     * @param spanId the span identifier of the span context.
     * @param traceOptions the trace options for the span context.
     * @param tracestate the trace state for the span context.
     * @return a new {@code SpanContext} with the given identifiers and options.
     * @since 0.1.0
     */
    public init(traceId: TraceId, spanId: SpanId, traceFlags: TraceFlags, tracestate: Tracestate? = nil) {
        self.traceId = traceId
        self.spanId = spanId
        self.traceFlags = traceFlags
        self.tracestate = tracestate ?? Tracestate()
    }

    /*
     * Returns true if this {@code SpanContext} is valid.
     *
     * @return true if this {@code SpanContext} is valid.
     * @since 0.1.0
     */
    public var isValid: Bool {
        return traceId.isValid && spanId.isValid
    }

    public static func == (lhs: SpanContext, rhs: SpanContext) -> Bool {
        return lhs.traceId == rhs.traceId && lhs.spanId == rhs.spanId && lhs.traceFlags == rhs.traceFlags
    }

    public var description: String {
        return "SpanContext{traceId=\(traceId), spanId=\(spanId), traceFlags=\(traceFlags)}"
    }
}
