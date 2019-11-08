//
//  SimpleSpanProcessor.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 05/11/2019.
//

import Foundation

struct SimpleSpanProcessor: SpanProcessor {
//    private static final Logger logger = Logger.getLogger(SimpleSpansProcessor.class.getName());

    private var spanExporter: SpanExporter
    private var sampled: Bool = true

    func onStart(span: ReadableSpan) {
    }

    mutating func onEnd(span: ReadableSpan) {
        if sampled && !span.context.traceFlags.sampled {
            return
        }
        let span = span.toSpanData()
        spanExporter.export(spans: [span])
    }

    mutating func shutdown() {
        spanExporter.shutdown()
    }

    init(spanExporter: SpanExporter) {
        self.spanExporter = spanExporter
    }

    func reportingOnlySampled(sampled: Bool) -> Self {
        var processor = self
        processor.sampled = sampled
        return processor
    }


}
