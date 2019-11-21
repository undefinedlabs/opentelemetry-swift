//
//  BatchSpanProcessor.swift
//
//  Created by Ignacio Bonafonte on 05/11/2019.
//

import Foundation

/// Implementation of the SpanProcessor that batches spans exported by the SDK then pushes
/// to the exporter pipeline.
/// All spans reported by the SDK implementation are first added to a synchronized queue (with a
/// maxQueueSize maximum size, after the size is reached spans are dropped) and exported
/// every scheduleDelayMillis to the exporter pipeline in batches of maxExportBatchSize.
/// If the queue gets half full a preemptive notification is sent to the worker thread that
/// exports the spans to wake up and start a new export cycle.
/// This batchSpanProcessor can cause high contention in a very high traffic service.
public struct BatchSpanProcessor /*: SpanProcessor */ {
    private let workerThreadName = "BatchSpanProcessor_WorkerThread"
    var sampled: Bool

    // TODO: Missing all
}
