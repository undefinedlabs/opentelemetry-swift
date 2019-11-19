//
//  SpanProcessor.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 04/11/2019.
//

import Foundation

/**
 * SpanProcessor is the interface {@code TracerSdk} uses to allow synchronous hooks for when a
 * {@code Span} is started or when a {@code Span} is ended.
 */
public protocol SpanProcessor {
    /**
     * Called when a {@link io.opentelemetry.trace.Span} is started, if the {@link Span#isRecording()}
     * returns true.
     *
     * <p>This method is called synchronously on the execution thread, should not throw or block the
     * execution thread.
     *
     * @param span the {@code ReadableSpan} that just started.
     */
    func onStart(span: ReadableSpan)

    /**
     * Called when a {@link io.opentelemetry.trace.Span} is ended, if the {@link Span#isRecording()}
     * returns true.
     *
     * <p>This method is called synchronously on the execution thread, should not throw or block the
     * execution thread.
     *
     * @param span the {@code ReadableSpan} that just ended.
     */
    // TODO: Consider checking whether the given span is processed with onStart().
    mutating func onEnd(span: ReadableSpan)

    /** Called when {@link TracerSdk#shutdown()} is called. */
    mutating func shutdown()
}
