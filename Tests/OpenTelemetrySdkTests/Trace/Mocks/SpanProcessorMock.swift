//
//  SpanProcessorMock.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 06/11/2019.
//

import Foundation
@testable import OpenTelemetrySdk

class SpanProcessorMock: SpanProcessor {
    var onStartCalledTimes = 0
    lazy var onStartCalled: Bool = { self.onStartCalledTimes > 0 }()
    var onStartCalledSpan: ReadableSpan?
    var onEndCalledTimes = 0
    lazy var onEndCalled: Bool = { self.onEndCalledTimes > 0 }()
    var onEndCalledSpan: ReadableSpan?
    var shutdownCalledTimes = 0
    lazy var shutdownCalled: Bool = { self.shutdownCalledTimes > 0 }()

    func onStart(span: ReadableSpan) {
        onStartCalledTimes += 1
        onStartCalledSpan = span
    }

    func onEnd(span: ReadableSpan) {
        onEndCalledTimes += 1
        onEndCalledSpan = span
    }

    func shutdown() {
        shutdownCalledTimes += 1
    }
}
