//
//  TracerSdkFactory.swift
//
//  Created by Ignacio Bonafonte on 18/11/2019.
//

import Foundation
import OpenTelemetryApi

public class TracerSdkFactory: TracerFactory {
//    let logger = Logger.getLogger(TracerFactory.class.getName());

    private var tracerRegistry = [InstrumentationLibraryInfo: TracerSdk]()
    private var sharedState: TracerSharedState

    /**
     * Returns a new {@link TracerSdkFactory} with default {@link Clock}, {@link IdsGenerator} and
     * {@link Resource}.
     *
     * @return a new {@link TracerSdkFactory} with default configs.
     */
    public convenience init() {
        self.init(clock: MillisClock(), idsGenerator: RandomIdsGenerator(), resource: EnvVarResource.resource)
    }

    init(clock: Clock, idsGenerator: IdsGenerator, resource: Resource) {
        sharedState = TracerSharedState(clock: clock, idsGenerator: idsGenerator, resource: resource)
    }

    public func get(instrumentationName: String, instrumentationVersion: String? = nil) -> Tracer {
        let instrumentationLibraryInfo = InstrumentationLibraryInfo(name: instrumentationName, version: instrumentationVersion ?? "")
        if let tracer = tracerRegistry[instrumentationLibraryInfo] {
            return tracer
        } else {
            // Re-check if the value was added since the previous check, this can happen if multiple
            // threads try to access the same named tracer during the same time. This way we ensure that
            // we create only one TracerSdk per name.
            if let tracer = tracerRegistry[instrumentationLibraryInfo] {
                // A different thread already added the named Tracer, just reuse.
                return tracer
            }
            let tracer = TracerSdk(sharedState: sharedState, instrumentationLibraryInfo: instrumentationLibraryInfo)
            tracerRegistry[instrumentationLibraryInfo] = tracer
            return tracer
        }
    }

    /**
     * Returns the active {@code TraceConfig}.
     *
     * @return the active {@code TraceConfig}.
     */
    public func getActiveTraceConfig() -> TraceConfig {
        sharedState.activeTraceConfig
    }

    /**
     * Updates the active {@link TraceConfig}.
     *
     * @param traceConfig the new active {@code TraceConfig}.
     */
    public func updateActiveTraceConfig(_ traceConfig: TraceConfig) {
        sharedState.setActiveTraceConfig(traceConfig)
    }

    /**
     * Adds a new {@code SpanProcessor} to this {@code Tracer}.
     *
     * Any registered processor cause overhead, consider to use an async/batch processor especially
     * for span exporting, and export to multiple backends using the {@link
     * io.opentelemetry.sdk.trace.export.MultiSpanExporter}.
     *
     * @param spanProcessor the new {@code SpanProcessor} to be added.
     */
    public func addSpanProcessor(_ spanProcessor: SpanProcessor) {
        sharedState.addSpanProcessor(spanProcessor)
    }

    /**
     * Attempts to stop all the activity for this {@link Tracer}. Calls {@link
     * SpanProcessor#shutdown()} for all registered {@link SpanProcessor}s.
     *
     * This operation may block until all the Spans are processed. Must be called before turning
     * off the main application to ensure all data are processed and exported.
     *
     * After this is called all the newly created {@code Span}s will be no-op.
     */
    public func shutdown() {
        if sharedState.isStopped {
//            logger.log(Level.WARNING, "Calling shutdown() multiple times.")
            return
        }
        sharedState.stop()
    }
}
