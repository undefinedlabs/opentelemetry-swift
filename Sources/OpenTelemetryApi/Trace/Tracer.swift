//
//  Tracer.swift
//
//
//  Created by Ignacio Bonafonte on 15/10/2019.
//

import Foundation

public protocol Tracer: AnyObject {
    /// Gets the current Span from the current Context.
    var currentSpan: Span? { get }

    /// Gets the BinaryFormat for this implementation.
    var binaryFormat: BinaryFormattable { get }

    /// Gets the ITextFormat for this implementation.
    var textFormat: TextFormattable { get }

    /// Returns a SpanBuilder to create and start a new Span
    /// - Parameter spanName: The name of the returned Span.
    func spanBuilder(spanName: String) -> SpanBuilder

    /// Associates the span with the current context.
    /// - Parameter span: Span to associate with the current context.
    func withSpan(_ span: Span) -> Scope

}
