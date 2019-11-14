//
//  TracerSdk.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 05/11/2019.
//

import Foundation

struct TracerSdk: Tracer {
//    private static final Logger logger = Logger.getLogger(TracerSdk.class.getName());

    var binaryFormat: BinaryFormattable = BinaryTraceContextFormat()
    var textFormat: TextFormattable = HttpTraceContextFormat()
    var clock = MillisClock()
    var resource = EnvVarResource.resource

    var activeTraceConfig = TraceConfig()

    private var activeSpanProcessor: SpanProcessor = NoopSpanProcessor()

    private var registeredSpanProcessors = [SpanProcessor]()

    private var isStopped = false

    var currentSpan: Span? {
        return ContextUtils.getCurrentSpan()
    }

    func spanBuilder(spanName: String) -> SpanBuilder {
        if isStopped {
            return DefaultTracer.instance.spanBuilder(spanName: spanName)
        }
        return SpanBuilderSdk(spanName: spanName, spanProcessor: activeSpanProcessor, traceConfig: activeTraceConfig, resource: resource, clock: clock)
    }

    func withSpan(_ span: Span) -> Scope {
        return ContextUtils.withSpan(span)
    }

    /**
     * Attempts to stop all the activity for this {@link Tracer}. Calls {@link
     * SpanProcessor#shutdown()} for all registered {@link SpanProcessor}s.
     *
     * <p>This operation may block until all the Spans are processed. Must be called before turning
     * off the main application to ensure all data are processed and exported.
     *
     * <p>After this is called all the newly created {@code Span}s will be no-op.
     */
    mutating func shutdown() {
        if isStopped {
            // logger.log(Level.WARNING, "Calling shutdown() multiple times.");
            return
        }
        activeSpanProcessor.shutdown()
        isStopped = true
    }

    // Restarts all the activity for this Tracer. Only used for unit testing.
    mutating func unsafeRestart() {
        isStopped = false
    }

    /**
     * Adds a new {@code SpanProcessor} to this {@code Tracer}.
     *
     * <p>Any registered processor cause overhead, consider to use an async/batch processor especially
     * for span exporting, and export to multiple backends using the {@link
     * io.opentelemetry.sdk.trace.export.MultiSpanExporter}.
     *
     * @param spanProcessor the new {@code SpanProcessor} to be added.
     */
    mutating func addSpanProcessor(spanProcessor: SpanProcessor) {
        registeredSpanProcessors.append(spanProcessor)
        activeSpanProcessor = MultiSpanProcessor(spanProcessors: registeredSpanProcessors)
    }
}
