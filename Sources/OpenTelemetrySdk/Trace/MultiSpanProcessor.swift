//
//  MultiSpanProcessor.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 05/11/2019.
//

import Foundation

/**
 * Implementation of the {@code SpanProcessor} that simply forwards all received events to a list of
 * {@code SpanProcessor}s.
 */
public struct MultiSpanProcessor: SpanProcessor {
    var spanProcessors = [SpanProcessor]()

    public init(spanProcessors: [SpanProcessor]) {
        self.spanProcessors = spanProcessors
    }

    public func onStart(span: ReadableSpan) {
        for processor in spanProcessors {
            processor.onStart(span: span)
        }
    }

    public func onEnd(span: ReadableSpan) {
        for var processor in spanProcessors {
            processor.onEnd(span: span)
        }
    }

    public func shutdown() {
        for var processor in spanProcessors {
            processor.shutdown()
        }
    }
}
