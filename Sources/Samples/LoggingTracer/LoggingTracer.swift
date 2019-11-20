//
//  LoggingTracer.swift
//  
//
//  Created by Ignacio Bonafonte on 19/11/2019.
//

import Foundation
import OpenTelemetryApi

class LoggingTracer: Tracer {

    let tracerName = "LoggingTracer"
    public var currentSpan: Span? {
        return ContextUtils.getCurrentSpan()
    }

    var binaryFormat: BinaryFormattable = BinaryTraceContextFormat()
    var textFormat: TextFormattable = HttpTraceContextFormat()


    func spanBuilder(spanName: String) -> SpanBuilder {
        return LoggingSpanBuilder(tracer: self, spanName: spanName)
    }

    func withSpan(_ span: Span) -> Scope {
         Logger.log("\(tracerName).WithSpan");
        return ContextUtils.withSpan(span)
    }

    class LoggingSpanBuilder: SpanBuilder {
        private var tracer: Tracer
        private var isRootSpan: Bool = false
        private var spanContext: SpanContext?
        private var name: String

        init(tracer: Tracer, spanName: String) {
            self.tracer = tracer
            self.name = spanName
        }

        func startSpan() -> Span {
            if spanContext == nil && !isRootSpan {
                spanContext = tracer.currentSpan?.context
            }
            return spanContext != nil && spanContext != SpanContext.invalid ? LoggingSpan(name: name, kind: .client) : DefaultSpan.random()
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
