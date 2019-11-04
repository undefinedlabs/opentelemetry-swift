//
//  Tracer.swift
//
//
//  Created by Ignacio Bonafonte on 15/10/2019.
//

import Foundation

public protocol Tracer {
    /**
     * Gets the current Span from the current Context.
     *
     * <p>To install a {@link Span} to the current Context use {@link #withSpan(Span)}.
     *
     * <p>startSpan methods do NOT modify the current Context {@code Span}.
     *
     * @return a default {@code Span} that does nothing and has an invalid {@link SpanContext} if no
     *     {@code Span} is associated with the current Context, otherwise the current {@code Span}
     *     from the Context.
     * @since 0.1.0
     */
    var currentSpan: Span? { get }

    /// <summary>
    /// Gets the <see cref="IBinaryFormat"/> for this implementation.
    /// </summary>
    var binaryFormat: BinaryFormat { get }

    /// <summary>
    /// Gets the <see cref="ITextFormat"/> for this implementation.
    /// </summary>
    var textFormat: TextFormattable { get }

    /**
     * Returns a {@link Span.Builder} to create and start a new {@link Span}.
     *
     * <p>See {@link Span.Builder} for usage examples.
     *
     * @param spanName The name of the returned Span.
     * @return a {@code Span.Builder} to create and start a new {@code Span}.
     * @throws NullPointerException if {@code spanName} is {@code null}.
     * @since 0.1.0
     */
    func spanBuilder(spanName: String) -> SpanBuilder

    /// <summary>
    /// Associates the span with the current context.
    /// </summary>
    /// <param name="span">Span to associate with the current context.</param>
    /// <returns>Disposable object to control span to current context association.</returns>
    func withSpan(span: Span) -> Scope

    // TODO: add sampling hints
    // TODO: add lazy links
//
//    /// <summary>
//    /// Creates root span.
//    /// </summary>
//    /// <param name="operationName">Span name.</param>
//    /// <param name="kind">Kind.</param>
//    /// <param name="startTimestamp">Start timestamp.</param>
//    /// <param name="links">Links collection.</param>
//    /// <returns>Span instance.</returns>
//    func startRootSpan(operationName: String, kind: SpanKind, startTimestamp: Timestamp, links: [Link]?) -> Span
//
//    /// <summary>
//    /// Creates span. If there is active current span, it becomes a parent for returned span.
//    /// </summary>
//    /// <param name="operationName">Span name.</param>
//    /// <param name="kind">Kind.</param>
//    /// <param name="startTimestamp">Start timestamp.</param>
//    /// <param name="links">Links collection.</param>
//    /// <returns>Span instance.</returns>
//    func startSpan(operationName: String, kind: SpanKind, startTimestamp: Timestamp, links: [Link]?) -> Span
//
//    /// <summary>
//    /// Creates span.
//    /// </summary>
//    /// <param name="operationName">Span name.</param>
//    /// <param name="parent">Parent for new span.</param>
//    /// <param name="kind">Kind.</param>
//    /// <param name="startTimestamp">Start timestamp.</param>
//    /// <param name="links">Links collection.</param>
//    /// <returns>Span instance.</returns>
//    func startSpan(operationName: String, parent: Span, kind: SpanKind, startTimestamp: Timestamp, links: [Link]?) -> Span
//
//    /// <summary>
//    /// Creates span.
//    /// </summary>
//    /// <param name="operationName">Span name.</param>
//    /// <param name="parent">Parent for new span.</param>
//    /// <param name="kind">Kind.</param>
//    /// <param name="startTimestamp">Start timestamp.</param>
//    /// <param name="links">Links collection.</param>
//    /// <returns>Span instance.</returns>
//    func startSpan(operationName: String, parent: SpanContext, kind: SpanKind, startTimestamp: Timestamp, links: [Link]?) -> Span
//
//    /// <summary>
//    /// Creates span from auto-collected System.Diagnostics.Activity.
//    /// </summary>
//    /// <param name="operationName">Span name.</param>
//    /// <param name="activity">Activity instance to create span from.</param>
//    /// <param name="kind">Kind.</param>
//    /// <param name="links">Links collection.</param>
//    /// <returns>Span instance.</returns>
////    ISpan StartSpanFromActivity(string operationName, Activity activity, SpanKind kind, IEnumerable<Link> links);
//}
//
//extension Tracer {
//    /// <summary>
//    /// Creates root span.
//    /// </summary>
//    /// <param name="operationName">Span name.</param>
//    /// <returns>Span instance.</returns>
//    public func startRootSpan(operationName: String) -> Span {
//        return startRootSpan(operationName: operationName, kind: SpanKind.Internal, startTimestamp: Timestamp(), links: nil)
//    }
//
//    /// <summary>
//    /// Creates root span.
//    /// </summary>
//    /// <param name="operationName">Span name.</param>
//    /// <param name="kind">Kind.</param>
//    /// <returns>Span instance.</returns>
//    public func startRootSpan(operationName: String, kind: SpanKind) -> Span {
//        return startRootSpan(operationName: operationName, kind: kind, startTimestamp: Timestamp(), links: nil)
//    }
//
//    /// <summary>
//    /// Creates span. If there is active current span, it becomes a parent for returned span.
//    /// </summary>
//    /// <param name="operationName">Span name.</param>
//    /// <returns>Span instance.</returns>
//    public func startSpan(operationName: String) -> Span {
//        return startSpan(operationName: operationName, kind: SpanKind.Internal, startTimestamp: Timestamp(), links: nil)
//    }
//
//    /// <summary>
//    /// Creates span. If there is active current span, it becomes a parent for returned span.
//    /// </summary>
//    /// <param name="operationName">Span name.</param>
//    /// <param name="kind">Kind.</param>
//    /// <returns>Span instance.</returns>
//    public func startSpan(operationName: String, kind: SpanKind) -> Span {
//        return startSpan(operationName: operationName, kind: kind, startTimestamp: Timestamp(), links: nil)
//    }
//
//    /// <summary>
//    /// Creates span.
//    /// </summary>
//    /// <param name="operationName">Span name.</param>
//    /// <param name="parent">Parent for new span.</param>
//    /// <returns>Span instance.</returns>
//    public func startSpan(operationName: String, parent: Span) -> Span {
//        return startSpan(operationName: operationName, parent: parent, kind: SpanKind.Internal, startTimestamp: Timestamp(), links: nil)
//    }
//
//    /// <summary>
//    /// Creates span.
//    /// </summary>
//    /// <param name="operationName">Span name.</param>
//    /// <param name="parent">Parent for new span.</param>
//    /// <param name="kind">Kind.</param>
//    /// <returns>Span instance.</returns>
//    public func startSpan(operationName: String, parent: Span, kind: SpanKind) -> Span {
//        return startSpan(operationName: operationName, parent: parent, kind: kind, startTimestamp: Timestamp(), links: nil)
//    }
//
//    /// <summary>
//    /// Creates span.
//    /// </summary>
//    /// <param name="operationName">Span name.</param>
//    /// <param name="parent">Parent for new span.</param>
//    /// <returns>Span instance.</returns>
//    public func startSpan(operationName: String, parent: SpanContext) -> Span {
//        return startSpan(operationName: operationName, parent: parent, kind: SpanKind.Internal, startTimestamp: Timestamp(), links: nil)
//    }
//
//    /// <summary>
//    /// Creates span.
//    /// </summary>
//    /// <param name="operationName">Span name.</param>
//    /// <param name="parent">Parent for new span.</param>
//    /// <param name="kind">Kind.</param>
//    /// <returns>Span instance.</returns>
//    public func startSpan(operationName: String, parent: SpanContext, kind: SpanKind) -> Span {
//        return startSpan(operationName: operationName, parent: parent, kind: kind, startTimestamp: Timestamp(), links: nil)
//    }
}
