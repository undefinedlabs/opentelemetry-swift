//
//  SimpleSpanProcessor.swift
//
//  Created by Ignacio Bonafonte on 05/11/2019.
//

import Foundation
import OpenTelemetryApi

/// An implementation of the SpanProcessor that converts the ReadableSpan SpanData
///  and passes it to the configured exporter.
public struct SimpleSpanProcessor: SpanProcessor {
    private var spanExporter: SpanExporter
    private var sampled: Bool = true

    public func onStart(span: ReadableSpan) {
    }

    public mutating func onEnd(span: ReadableSpan) {
        if sampled && !span.context.traceFlags.sampled {
            return
        }
        let span = span.toSpanData()
        spanExporter.export(spans: [span])
    }

    public mutating func shutdown() {
        spanExporter.shutdown()
    }

    /// Returns a new SimpleSpansProcessor that converts spans to proto and forwards them to
    /// the given spanExporter.
    /// - Parameter spanExporter: the SpanExporter to where the Spans are pushed.
    public init(spanExporter: SpanExporter) {
        self.spanExporter = spanExporter
    }

    /// Set whether only sampled spans should be reported.
    /// - Parameter sampled: report only sampled spans.
    public func reportingOnlySampled(sampled: Bool) -> Self {
        var processor = self
        processor.sampled = sampled
        return processor
    }
}
