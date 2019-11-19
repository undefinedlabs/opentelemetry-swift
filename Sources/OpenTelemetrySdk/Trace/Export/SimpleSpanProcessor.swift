//
//  SimpleSpanProcessor.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 05/11/2019.
//

import Foundation
import OpenTelemetryApi

public struct SimpleSpanProcessor: SpanProcessor {
//    private static final Logger logger = Logger.getLogger(SimpleSpansProcessor.class.getName());

    private var spanExporter: SpanExporter
    private var sampled: Bool = true

    public func onStart(span: ReadableSpan) {
    }

    mutating public func onEnd(span: ReadableSpan) {
        if sampled && !span.context.traceFlags.sampled {
            return
        }
        let span = span.toSpanData()
        spanExporter.export(spans: [span])
    }

    mutating public func shutdown() {
        spanExporter.shutdown()
    }

    public init(spanExporter: SpanExporter) {
        self.spanExporter = spanExporter
    }

    public func reportingOnlySampled(sampled: Bool) -> Self {
        var processor = self
        processor.sampled = sampled
        return processor
    }
}
