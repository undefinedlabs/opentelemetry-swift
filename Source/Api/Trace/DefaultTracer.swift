//
//  DefaultTracer.swift
//
//
//  Created by Ignacio Bonafonte on 22/10/2019.
//

import Foundation

class DefaultTracer: Tracer {
    static var instance = DefaultTracer()
    var binaryFormat = BinaryFormat()
    var textFormat: TextFormattable = HttpTraceContextFormat()

    var currentSpan: Span? {
        return ContextUtils.getCurrent()
    }

    func withSpan(span: Span) -> Scope {
        return SpanInScope(span: span)
    }

    func spanBuilder(spanName: String) -> SpanBuilder {
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
            return spanContext != nil && spanContext != SpanContext.invalid ? DefaultSpan(context: spanContext!) : DefaultSpan.createRandom()
        }

        func setParent(parent: Span) -> SpanBuilder {
            spanContext = parent.context
            return self
        }

        func setParent(parent: SpanContext) -> SpanBuilder {
            spanContext = parent
            return self
        }

        func setNoParent() -> SpanBuilder {
            isRootSpan = true
            return self
        }

        func setSampler(sampler: Sampler) -> SpanBuilder {
            return self
        }

        func addLink(spanContext: SpanContext) -> SpanBuilder {
            return self
        }

        func addLink(spanContext: SpanContext, attributes: [String: AttributeValue]) -> SpanBuilder {
            return self
        }

        func addLink(link: Link) -> SpanBuilder {
            return self
        }

        func setSpanKind(spanKind: SpanKind) -> SpanBuilder {
            return self
        }

        func setStartTimestamp(startTimestamp: Timestamp) -> SpanBuilder {
            return self
        }
    }
}
