//
//  BatchSpanProcessor.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 05/11/2019.
//

import Foundation

/**
* Implementation of the {@link SpanProcessor} that batches spans exported by the SDK then pushes
* them to the exporter pipeline.
*
* All spans reported by the SDK implementation are first added to a synchronized queue (with a
* {@code maxQueueSize} maximum size, after the size is reached spans are dropped) and exported
* every {@code scheduleDelayMillis} to the exporter pipeline in batches of {@code
* maxExportBatchSize}.
*
* If the queue gets half full a preemptive notification is sent to the worker thread that
* exports the spans to wake up and start a new export cycle.
*
* This batch {@link SpanProcessor} can cause high contention in a very high traffic service.
* TODO: Add a link to the SpanProcessor that uses Disruptor as alternative with low contention.
*/

//TODO: Missing all
public struct BatchSpanProcessor/*: SpanProcessor*/ {
    private let workerThreadName = "BatchSpanProcessor_WorkerThread"
    var sampled: Bool

    
}
