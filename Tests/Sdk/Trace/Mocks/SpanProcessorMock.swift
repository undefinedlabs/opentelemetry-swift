//
//  SpanProcessorMock.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 06/11/2019.
//

@testable import OpenTelemetrySwift
import Foundation

class SpanProcessorMock: SpanProcessor {

    var onStartCalled = false
    var onStartCalledSpan: ReadableSpan?
    var onEndCalled = false
    var onEndCalledSpan: ReadableSpan?
    var shutdownCalled = false


    func onStart(span: ReadableSpan) {
        onStartCalled = true
        onStartCalledSpan = span
    }

    func onEnd(span: ReadableSpan) {
        onEndCalled = true
        onEndCalledSpan = span
    }

    func shutdown() {
        shutdownCalled = true
    }

}
