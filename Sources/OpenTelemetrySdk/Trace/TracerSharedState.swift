//
//  TracerSharedState.swift
//
//  Created by Ignacio Bonafonte on 18/11/2019.
//

import Foundation

/// Represents the shared state/config between all Tracers created by the same TracerFactory.
public class TracerSharedState {

    public private(set) var clock: Clock
    public private(set) var idsGenerator: IdsGenerator
    public private(set) var resource: Resource

    public private(set) var activeTraceConfig = TraceConfig()
    public private(set) var activeSpanProcessor: SpanProcessor = NoopSpanProcessor()
    public private(set) var isStopped = false

    private var registeredSpanProcessors =  [SpanProcessor]()

    public init(clock: Clock, idsGenerator: IdsGenerator, resource: Resource) {
        self.clock = clock
        self.idsGenerator = idsGenerator
        self.resource = resource
    }


    /// Adds a new SpanProcessor
    /// - Parameter spanProcessor:  the new SpanProcessor to be added.
    public func addSpanProcessor(_ spanProcessor: SpanProcessor) {
        registeredSpanProcessors.append(spanProcessor);
        activeSpanProcessor = MultiSpanProcessor(spanProcessors: registeredSpanProcessors);
    }

    /// Stops tracing, including shutting down processors and set to true isStopped.
    public func stop() {
         if (isStopped) {
           return;
         }
         activeSpanProcessor.shutdown();
         isStopped = true;
     }

    internal func setActiveTraceConfig(_ activeTraceConfig: TraceConfig) {
        self.activeTraceConfig = activeTraceConfig
    }
}
