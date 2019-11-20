//
//  DefaultTracer.swift
//
//
//  Created by Ignacio Bonafonte on 22/10/2019.
//

import Foundation

public class DefaultTracer: Tracer {

    public static var instance = DefaultTracer()
    public var binaryFormat: BinaryFormattable = BinaryTraceContextFormat()
    public var textFormat: TextFormattable = HttpTraceContextFormat()

    private init() {}

    public var currentSpan: Span? {
        return ContextUtils.getCurrentSpan()
    }

    public func withSpan(_ span: Span) -> Scope {
        return SpanInScope(span: span)
    }

    public func spanBuilder(spanName: String) -> SpanBuilder {
        return DefaultSpanBuilder(tracer: self, spanName: spanName)
    }
}
