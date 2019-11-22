//
//  SimpleStdoutExporter.swift
//  
//
//  Created by Ignacio Bonafonte on 22/11/2019.
//

import Foundation
import OpenTelemetrySdk

class SimpleStdoutExporter: SpanExporter {
    func export(spans: [SpanData]) -> SpanExporterResultCode {
        for span in spans {
            print("__________________")
            print("Span \(span.name):")
            print("TraceId: \(span.traceId.hexString)")
            print("kind: \(span.kind.rawValue)")
            print("SpanId: \(span.spanId.hexString)")
            print("TraceFlags: \(span.traceFlags)")
            print("Tracestate: \(span.tracestate)")
            print("ParentSpanId: \(span.parentSpanId?.hexString ?? "no Parent")")
            print("Start: \(span.startEpochNanos)")
            print("Duration: \(span.endEpochNanos - span.startEpochNanos)")
            print("------------------\n")
        }
        return .success
    }

    func shutdown() {
    }
}
