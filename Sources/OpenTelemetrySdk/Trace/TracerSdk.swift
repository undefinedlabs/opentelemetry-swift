//
//  TracerSdk.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 05/11/2019.
//

import Foundation
import OpenTelemetryApi

struct TracerSdk: Tracer {
//    private static final Logger logger = Logger.getLogger(TracerSdk.class.getName());

    var binaryFormat: BinaryFormattable = BinaryTraceContextFormat()
    var textFormat: TextFormattable = HttpTraceContextFormat()

    var sharedState: TracerSharedState
    var instrumentationLibraryInfo : InstrumentationLibraryInfo

    private var isStopped = false

    init(sharedState: TracerSharedState, instrumentationLibraryInfo : InstrumentationLibraryInfo) {
        self.sharedState = sharedState
        self.instrumentationLibraryInfo = instrumentationLibraryInfo
    }

    var currentSpan: Span? {
        return ContextUtils.getCurrentSpan()
    }

    func spanBuilder(spanName: String) -> SpanBuilder {
        if isStopped {
            return DefaultTracer.instance.spanBuilder(spanName: spanName)
        }
        return SpanBuilderSdk(spanName: spanName, instrumentationLibraryInfo: instrumentationLibraryInfo, spanProcessor: sharedState.activeSpanProcessor, traceConfig: sharedState.activeTraceConfig, resource: sharedState.resource, idsGenerator: sharedState.idsGenerator, clock: sharedState.clock)
    }

    dynamic func withSpan(_ span: Span) -> Scope {
        return ContextUtils.withSpan(span)
    }
}
