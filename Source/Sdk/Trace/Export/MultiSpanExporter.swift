//
//  MultiSpanExporter.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 05/11/2019.
//

import Foundation

class MultiSpanExporter: SpanExporter {
//    private static final Logger logger = Logger.getLogger(MultiSpanExporter.class.getName());
    var spanExporters: [SpanExporter]

    init(spanExporters: [SpanExporter]) {
        self.spanExporters = spanExporters
    }

    func export(spans: [SpanData]) -> SpanExporterResultCode {
        var currentResultCode = SpanExporterResultCode.success
        for exporter in spanExporters {
            currentResultCode.mergeResultCode(newResultCode: exporter.export(spans: spans))
        }
        return currentResultCode
    }

    func shutdown() {
        for exporter in spanExporters {
            exporter.shutdown()
        }
    }
}
