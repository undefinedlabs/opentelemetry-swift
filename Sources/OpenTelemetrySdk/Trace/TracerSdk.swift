//
//  TracerSdk.swift
//
//  Created by Ignacio Bonafonte on 05/11/2019.
//

import Foundation
import OpenTelemetryApi

/// TracerSdk is SDK implementation of Tracer.
public class TracerSdk: Tracer {
    public let binaryFormat: BinaryFormattable = BinaryTraceContextFormat()
    public let textFormat: TextFormattable = HttpTraceContextFormat()
    public var sharedState: TracerSharedState
    public var instrumentationLibraryInfo: InstrumentationLibraryInfo

    public init(sharedState: TracerSharedState, instrumentationLibraryInfo: InstrumentationLibraryInfo) {
        self.sharedState = sharedState
        self.instrumentationLibraryInfo = instrumentationLibraryInfo
    }

    public var currentSpan: Span? {
        return ContextUtils.getCurrentSpan()
    }

    public func spanBuilder(spanName: String) -> SpanBuilder {
        if sharedState.isStopped {
            return DefaultTracer.instance.spanBuilder(spanName: spanName)
        }
        return SpanBuilderSdk(spanName: spanName, instrumentationLibraryInfo: instrumentationLibraryInfo, spanProcessor: sharedState.activeSpanProcessor, traceConfig: sharedState.activeTraceConfig, resource: sharedState.resource, idsGenerator: sharedState.idsGenerator, clock: sharedState.clock)
    }

    public func withSpan(_ span: Span) -> Scope {
        return ContextUtils.withSpan(span)
    }
}
