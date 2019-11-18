//
//  SpanExporter.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 05/11/2019.
//

import Foundation

/** The possible results for the export method. */
enum SpanExporterResultCode {
    /** The export operation finished successfully. */
    case success
    /** The export operation finished with an error, but retrying may succeed. */
    case failedRetryable
    /**
     * The export operation finished with an error, the caller should not try to export the same
     * data again.
     */
    case failedNotRetryable

    mutating func mergeResultCode(newResultCode: SpanExporterResultCode) {
        // If both errors are success then return success.
        if self == .success && newResultCode == .success {
            self = .success
            return
        }

        // If any of the codes is none retryable then return none_retryable;
        if self == .failedNotRetryable || newResultCode == .failedNotRetryable {
            self = .failedNotRetryable
            return
        }

        // At this point at least one of the code is FAILED_RETRYABLE and none are
        // FAILED_NOT_RETRYABLE, so return FAILED_RETRYABLE.
        self = .failedRetryable
    }
}

protocol SpanExporter: AnyObject {
    /**
     * Called to export sampled {@code Span}s.
     *
     * @param spans the list of sampled Spans to be exported.
     * @return the result of the export.
     */
    @discardableResult func export(spans: [SpanData]) -> SpanExporterResultCode

    /**
     * Called when {@link TracerSdk#shutdown()} is called, if this {@code SpanExporter} is register to
     * a {@code TracerSdk} object.
     */
    func shutdown()
}
