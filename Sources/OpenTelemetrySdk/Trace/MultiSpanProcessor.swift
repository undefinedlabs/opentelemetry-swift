//
//  MultiSpanProcessor.swift
//
//  Created by Ignacio Bonafonte on 05/11/2019.
//

import Foundation

/// Implementation of the SpanProcessor that simply forwards all received events to a list of
/// SpanProcessors.
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
