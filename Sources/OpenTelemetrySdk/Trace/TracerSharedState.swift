//
//  TracerSharedState.swift
//
//
//  Created by Ignacio Bonafonte on 18/11/2019.
//

import Foundation

class TracerSharedState {
    private(set) var clock: Clock
    private(set) var idsGenerator: IdsGenerator
    private(set) var resource: Resource

    var activeTraceConfig = TraceConfig()
    private(set) var activeSpanProcessor: SpanProcessor = NoopSpanProcessor()
    private(set) var isStopped = false

    private var registeredSpanProcessors =  [SpanProcessor]()

    init(clock: Clock, idsGenerator: IdsGenerator, resource: Resource) {
        self.clock = clock
        self.idsGenerator = idsGenerator
        self.resource = resource
    }

    public func addSpanProcessor(_ spanProcessor: SpanProcessor) {
        registeredSpanProcessors.append(spanProcessor);
        activeSpanProcessor = MultiSpanProcessor(spanProcessors: registeredSpanProcessors);
    }

    public func stop() {
         if (isStopped) {
           return;
         }
         activeSpanProcessor.shutdown();
         isStopped = true;
     }
}
