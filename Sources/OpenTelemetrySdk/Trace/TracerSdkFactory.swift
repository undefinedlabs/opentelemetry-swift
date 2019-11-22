//
//  TracerSdkFactory.swift
//
//  Created by Ignacio Bonafonte on 18/11/2019.
//

import Foundation
import OpenTelemetryApi

/// This class is not intended to be used in application code and it is used only by OpenTelemetry.
public class TracerSdkFactory: TracerFactory {
    private var tracerRegistry = [InstrumentationLibraryInfo: TracerSdk]()
    private var sharedState: TracerSharedState

    /// Returns a new TracerSdkFactory with default Clock, IdsGenerator and Resource.
    public convenience override init() {
        self.init(clock: MillisClock(), idsGenerator: RandomIdsGenerator(), resource: EnvVarResource.resource)
    }

    init(clock: Clock, idsGenerator: IdsGenerator, resource: Resource) {
        sharedState = TracerSharedState(clock: clock, idsGenerator: idsGenerator, resource: resource)
        super.init()
    }

    public override func get(instrumentationName: String, instrumentationVersion: String? = nil) -> Tracer {
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

    /// Returns the active TraceConfig.
    public func getActiveTraceConfig() -> TraceConfig {
        sharedState.activeTraceConfig
    }

    /// Updates the active TraceConfig.
    public func updateActiveTraceConfig(_ traceConfig: TraceConfig) {
        sharedState.setActiveTraceConfig(traceConfig)
    }

    /// Adds a new SpanProcessor to this Tracer.
    /// Any registered processor cause overhead, consider to use an async/batch processor especially
    /// for span exporting, and export to multiple backends using the MultiSpanExporter
    /// - Parameter spanProcessor: the new SpanProcessor to be added.
    public func addSpanProcessor(_ spanProcessor: SpanProcessor) {
        sharedState.addSpanProcessor(spanProcessor)
    }

     /// Attempts to stop all the activity for this Tracer. Calls SpanProcessor.shutdown()
    /// for all registered SpanProcessors.
     /// This operation may block until all the Spans are processed. Must be called before turning
     /// off the main application to ensure all data are processed and exported.
     /// After this is called all the newly created Spanss will be no-op.
    public func shutdown() {
        if sharedState.isStopped {
            return
        }
        sharedState.stop()
    }
}
