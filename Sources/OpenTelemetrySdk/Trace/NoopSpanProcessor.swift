//
//  NoopSpanProcessor.swift
//
//  Created by Ignacio Bonafonte on 05/11/2019.
//

import Foundation

public struct NoopSpanProcessor: SpanProcessor {
    public func onStart(span: ReadableSpan) {
    }

    public func onEnd(span: ReadableSpan) {
    }

    public func shutdown() {
    }
}
