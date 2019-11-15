//
//  NoopSpanProcessor.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 05/11/2019.
//

import Foundation

struct NoopSpanProcessor: SpanProcessor {
    func onStart(span: ReadableSpan) {
    }

    func onEnd(span: ReadableSpan) {
    }

    func shutdown() {
    }
}
