//
//  SpanProcessor.swift
//  Created by Ignacio Bonafonte on 04/11/2019.
//

import Foundation

/// SpanProcessor is the interface TracerSdk uses to allow synchronous hooks for when a Span
/// is started or when a Span is ended.
public protocol SpanProcessor {
    /// Called when a Span is started, if the Span.isRecording is true.
    /// This method is called synchronously on the execution thread, should not throw or block the
    /// execution thread.
    /// - Parameter span: the ReadableSpan that just started
    func onStart(span: ReadableSpan)

    /// Called when a Span is ended, if the Span.isRecording() is true.
    /// This method is called synchronously on the execution thread, should not throw or block the
    /// execution thread.
    /// - Parameter span: the ReadableSpan that just ended.
    mutating func onEnd(span: ReadableSpan)

    /// Called when TracerSdk.shutdown() is called.
    mutating func shutdown()
}
