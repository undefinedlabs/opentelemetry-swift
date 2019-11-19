//
//  File.swift
//
//
//  Created by Ignacio Bonafonte on 22/10/2019.
//

public protocol SpanBuilder: class {
    /**
     * Sets the parent {@code Span} to use. If not set, the value of {@code Tracer.getCurrentSpan()}
     * at {@link #startSpan()} time will be used as parent.
     *
     * <p>This <b>must</b> be used to create a {@code Span} when manual Context propagation is used
     * OR when creating a root {@code Span} with a parent with an invalid {@link SpanContext}.
     *
     * <p>Observe this is the preferred method when the parent is a {@code Span} created within the
     * process. Using its {@code SpanContext} as parent remains as a valid, albeit inefficient,
     * operation.
     *
     * <p>If called multiple times, only the last specified value will be used. Observe that the
     * state defined by a previous call to {@link #setNoParent()} will be discarded.
     *
     * @param parent the {@code Span} used as parent.
     * @return this.
     * @throws NullPointerException if {@code parent} is {@code null}.
     * @see #setNoParent()
     * @since 0.1.0
     */
    @discardableResult func setParent(_ parent: Span) -> SpanBuilder

    /**
     * Sets the parent {@link SpanContext} to use. If not set, the value of {@code
     * Tracer.getCurrentSpan()} at {@link #startSpan()} time will be used as parent.
     *
     * <p>Similar to {@link #setParent(Span parent)} but this <b>must</b> be used to create a {@code
     * Span} when the parent is in a different process. This is only intended for use by RPC systems
     * or similar.
     *
     * <p>If no {@link SpanContext} is available, users must call {@link #setNoParent()} in order to
     * create a root {@code Span} for a new trace.
     *
     * <p>If called multiple times, only the last specified value will be used. Observe that the
     * state defined by a previous call to {@link #setNoParent()} will be discarded.
     *
     * @param remoteParent the {@link SpanContext} used as parent.
     * @return this.
     * @throws NullPointerException if {@code remoteParent} is {@code null}.
     * @see #setParent(Span parent)
     * @see #setNoParent()
     * @since 0.1.0
     */
    @discardableResult func setParent(_ parent: SpanContext) -> SpanBuilder

    /**
     * Sets the option to become a root {@code Span} for a new trace. If not set, the value of
     * {@code Tracer.getCurrentSpan()} at {@link #startSpan()} time will be used as parent.
     *
     * <p>Observe that any previously set parent will be discarded.
     *
     * @return this.
     * @since 0.1.0
     */
    @discardableResult func setNoParent() -> SpanBuilder

    /**
     * Adds a {@link Link} to the newly created {@code Span}.
     *
     * @param spanContext the context of the linked {@code Span}.
     * @return this.
     * @throws NullPointerException if {@code spanContext} is {@code null}.
     * @see #addLink(Link)
     * @since 0.1.0
     */
    @discardableResult func addLink(spanContext: SpanContext) -> SpanBuilder

    /**
     * Adds a {@link Link} to the newly created {@code Span}.
     *
     * @param spanContext the context of the linked {@code Span}.
     * @param attributes the attributes of the {@code Link}.
     * @return this.
     * @throws NullPointerException if {@code spanContext} is {@code null}.
     * @throws NullPointerException if {@code attributes} is {@code null}.
     * @see #addLink(Link)
     * @since 0.1.0
     */
    @discardableResult func addLink(spanContext: SpanContext, attributes: [String: AttributeValue]) -> SpanBuilder

    /**
     * Adds a {@link Link} to the newly created {@code Span}.
     *
     * <p>Links are used to link {@link Span}s in different traces. Used (for example) in batching
     * operations, where a single batch handler processes multiple requests from different traces or
     * the same trace.
     *
     * @param link the {@link Link} to be added.
     * @return this.
     * @throws NullPointerException if {@code link} is {@code null}.
     * @since 0.1.0
     */
    @discardableResult func addLink(_ link: Link) -> SpanBuilder

    /**
     * Sets the {@link Span.Kind} for the newly created {@code Span}. If not called, the
     * implementation will provide a default value {@link Span.Kind#INTERNAL}.
     *
     * @param spanKind the kind of the newly created {@code Span}.
     * @return this.
     * @since 0.1.0
     */
    @discardableResult func setSpanKind(spanKind: SpanKind) -> SpanBuilder

     /**
        * Sets an explicit start timestamp for the newly created {@code Span}.
        *
        * <p>Use this method to specify an explicit start timestamp. If not called, the implementation
        * will use the timestamp value at {@link #startSpan()} time, which should be the default case.
        *
        * <p>Important this is NOT equivalent with System.nanoTime().
        *
        * @param startTimestamp the explicit start timestamp of the newly created {@code Span} in nanos
        *     since epoch.
        * @return this.
        * @since 0.1.0
        */
    @discardableResult func setStartTimestamp(startTimestamp: Int) -> SpanBuilder

    /**
     * Starts a new {@link Span}.
     *
     * <p>Users <b>must</b> manually call {@link Span#end()} to end this {@code Span}.
     *
     * <p>Does not install the newly created {@code Span} to the current Context.
     *
     * <p>Example of usage:
     *
     * <pre>{@code
     * class MyClass {
     *   private static final Tracer tracer = OpenTelemetry.getTracer();
     *   void DoWork(Span parent) {
     *     Span childSpan = tracer.spanBuilder("MyChildSpan")
     *          .setParent(parent)
     *          .startSpan();
     *     childSpan.addEvent("my event");
     *     try {
     *       doSomeWork(childSpan); // Manually propagate the new span down the stack.
     *     } finally {
     *       // To make sure we end the span even in case of an exception.
     *       childSpan.end();  // Manually end the span.
     *     }
     *   }
     * }
     * }</pre>
     *
     * @return the newly created {@code Span}.
     * @since 0.1.0
     */
    func startSpan() -> Span
}
