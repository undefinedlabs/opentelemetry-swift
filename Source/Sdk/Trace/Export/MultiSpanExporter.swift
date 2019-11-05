//
//  MultiSpanExporter.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 05/11/2019.
//

import Foundation

struct MultiSpanExporter: SpanExporter {
//    private static final Logger logger = Logger.getLogger(MultiSpanExporter.class.getName());
    var spanExporters: [SpanExporter]

    init(spanExporters: [SpanExporter]) {
        self.spanExporters = spanExporters
    }

    func export(spans: [SpanData]) -> SpanExporterResultCode {
        var currentResultCode = SpanExporterResultCode.success
        for var exporter in spanExporters {
            currentResultCode.mergeResultCode(newResultCode: exporter.export(spans: spans))
        }
        return currentResultCode
    }

    func shutdown() {
        for var exporter in spanExporters {
            exporter.shutdown()
        }
    }

    private static func mergeResultCode(currentResultCode: SpanExporterResultCode, newResultCode: SpanExporterResultCode) -> SpanExporterResultCode {
        // If both errors are success then return success.
        if currentResultCode == .success && newResultCode == .success {
            return .success
        }

        // If any of the codes is none retryable then return none_retryable;
        if currentResultCode == .failedNotRetryable || newResultCode == .failedNotRetryable {
            return .failedNotRetryable
        }

        // At this point at least one of the code is FAILED_RETRYABLE and none are
        // FAILED_NOT_RETRYABLE, so return FAILED_RETRYABLE.
        return .failedRetryable
    }
}
