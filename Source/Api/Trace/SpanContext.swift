//
//  SpanContext.swift
//
//
//  Created by Ignacio Bonafonte on 14/10/2019.
//

import Foundation
import ObjectiveC
import os.activity

// Bridging Obj-C variabled defined as c-macroses. See `activity.h` header.
private let OS_ACTIVITY_NONE = unsafeBitCast(dlsym(UnsafeMutableRawPointer(bitPattern: -2), "_os_activity_none"), to: os_activity_t.self)
private let OS_ACTIVITY_CURRENT = unsafeBitCast(dlsym(UnsafeMutableRawPointer(bitPattern: -2), "_os_activity_current"), to: os_activity_t.self)
@_silgen_name("_os_activity_create") private func _os_activity_create(_ dso: UnsafeRawPointer?, _ description: UnsafePointer<Int8>, _ parent : Unmanaged<AnyObject>?, _ flags: os_activity_flag_t) -> AnyObject!

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
    private(set) var traceId: TraceId

    /// The span identifier associated with this  SpanContext
    private(set) var spanId: SpanId

    /// The traceFlags associated with this SpanContext
    private(set) var traceFlags: TraceFlags

    /// The tracestate associated with this SpanContext
    let tracestate: Tracestate

    private var activityIdHandle: UInt8 = 0

    private var activity_state = os_activity_scope_state_s()

    private(set) var activityId: os_activity_id_t

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

        let dso = UnsafeMutableRawPointer(mutating: #dsohandle)
        let activity = _os_activity_create(dso, "InitSpan", OS_ACTIVITY_CURRENT, OS_ACTIVITY_FLAG_DEFAULT);
        activityId =  os_activity_get_identifier(activity, nil)
        os_activity_scope_enter(activity, &activity_state);
    }

    /*
     * Returns true if this {@code SpanContext} is valid.
     *
     * @return true if this {@code SpanContext} is valid.
     * @since 0.1.0
     */
    var isValid: Bool {
        return traceId.isValid && spanId.isValid
    }

    public static func == (lhs: SpanContext, rhs: SpanContext) -> Bool {
        return lhs.traceId == rhs.traceId && lhs.spanId == rhs.spanId && lhs.traceFlags == rhs.traceFlags
    }

    public var description: String {
        return "SpanContext{traceId=\(traceId), spanId=\(spanId), traceFlags=\(traceFlags)}"
    }
}
