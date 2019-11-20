//
//  MultiSpanExporter.swift
//
//  Created by Ignacio Bonafonte on 05/11/2019.
//

import Foundation

public class MultiSpanExporter: SpanExporter {
//    private static final Logger logger = Logger.getLogger(MultiSpanExporter.class.getName());
    var spanExporters: [SpanExporter]

    public init(spanExporters: [SpanExporter]) {
        self.spanExporters = spanExporters
    }

    public func export(spans: [SpanData]) -> SpanExporterResultCode {
        var currentResultCode = SpanExporterResultCode.success
        for exporter in spanExporters {
            currentResultCode.mergeResultCode(newResultCode: exporter.export(spans: spans))
        }
        return currentResultCode
    }

    public func shutdown() {
        for exporter in spanExporters {
            exporter.shutdown()
        }
    }
}
