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
        return NoopSpanBuilder(tracer: self, spanName: spanName)
    }

    class NoopSpanBuilder: SpanBuilder {
        private var tracer: Tracer
        private var isRootSpan: Bool = false
        private var spanContext: SpanContext?

        init(tracer: Tracer, spanName: String) {
            self.tracer = tracer
        }

        func startSpan() -> Span {
            if spanContext == nil && !isRootSpan {
                spanContext = tracer.currentSpan?.context
            }
            return spanContext != nil && spanContext != SpanContext.invalid ? DefaultSpan(context: spanContext!) : DefaultSpan.random()
        }

        func setParent(_ parent: Span) -> SpanBuilder {
            spanContext = parent.context
            return self
        }

        func setParent(_ parent: SpanContext) -> SpanBuilder {
            spanContext = parent
            return self
        }

        func setNoParent() -> SpanBuilder {
            isRootSpan = true
            return self
        }

        func addLink(spanContext: SpanContext) -> SpanBuilder {
            return self
        }

        func addLink(spanContext: SpanContext, attributes: [String: AttributeValue]) -> SpanBuilder {
            return self
        }

        func addLink(_ link: Link) -> SpanBuilder {
            return self
        }

        func setSpanKind(spanKind: SpanKind) -> SpanBuilder {
            return self
        }

        func setStartTimestamp(startTimestamp: Int) -> SpanBuilder {
            return self
        }
    }
}
