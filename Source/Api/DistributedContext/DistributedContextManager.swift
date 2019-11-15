//
//  DistributedContextManager.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 14/11/2019.
//

import Foundation

protocol DistributedContextManager: AnyObject {
    /**
     * Returns the current {@code DistributedContext}.
     *
     * @return the current {@code DistributedContext}.
     * @since 0.1.0
     */
    func getCurrentContext() -> DistributedContext

    /**
     * Returns a new {@code Builder}.
     *
     * @return a new {@code Builder}.
     * @since 0.1.0
     */
    func contextBuilder() -> DistributedContextBuilder

    /**
     * Enters the scope of code where the given {@code DistributedContext} is in the current context
     * (replacing the previous {@code DistributedContext}) and returns an object that represents that
     * scope. The scope is exited when the returned object is closed.
     *
     * @param distContext the {@code DistributedContext} to be set as the current context.
     * @return an object that defines a scope where the given {@code DistributedContext} is set as the
     *     current context.
     * @since 0.1.0
     */
    func withContext(distContext: DistributedContext) -> Scope

    /**
     * Returns the {@link BinaryFormat} for this implementation.
     *
     * <p>Example of usage on the client:
     *
     * <pre>{@code
     * private static final DistributedContextManager contextManager =
     *     OpenTelemetry.getDistributedContextManager();
     * private static final BinaryFormat binaryFormat = contextManager.getBinaryFormat();
     *
     * Request createRequest() {
     *   Request req = new Request();
     *   byte[] ctxBuffer = binaryFormat.toByteArray(contextManager.getCurrentContext());
     *   request.addMetadata("distributedContext", ctxBuffer);
     *   return request;
     * }
     * }</pre>
     *
     * <p>Example of usage on the server:
     *
     * <pre>{@code
     * private static final DistributedContextManager contextManager =
     *     OpenTelemetry.getDistributedContextManager();
     * private static final BinaryFormat binaryFormat = contextManager.getBinaryFormat();
     *
     * void onRequestReceived(Request request) {
     *   byte[] ctxBuffer = request.getMetadata("distributedContext");
     *   DistributedContext distContext = textFormat.fromByteArray(ctxBuffer);
     *   try (Scope s = contextManager.withContext(distContext)) {
     *     // Handle request and send response back.
     *   }
     * }
     * }</pre>
     *
     * @return the {@code BinaryFormat} for this implementation.
     * @since 0.1.0
     */
    func getBinaryFormat() -> BinaryFormattable

    /**
     * Returns the {@link HttpTextFormat} for this implementation.
     *
     * <p>Usually this will be the W3C Correlation Context as the HTTP text format. For more details,
     * see <a href="https://github.com/w3c/correlation-context">correlation-context</a>.
     *
     * <p>Example of usage on the client:
     *
     * <pre>{@code
     * private static final DistributedContextManager contextManager =
     *     OpenTelemetry.getDistributedContextManager();
     * private static final HttpTextFormat textFormat = contextManager.getHttpTextFormat();
     *
     * private static final HttpTextFormat.Setter setter =
     *     new HttpTextFormat.Setter<HttpURLConnection>() {
     *       public void put(HttpURLConnection carrier, String key, String value) {
     *         carrier.setRequestProperty(field, value);
     *       }
     *     };
     *
     * void makeHttpRequest() {
     *   HttpURLConnection connection =
     *       (HttpURLConnection) new URL("http://myserver").openConnection();
     *   textFormat.inject(contextManager.getCurrentContext(), connection, httpURLConnectionSetter);
     *   // Send the request, wait for response and maybe set the status if not ok.
     * }
     * }</pre>
     *
     * <p>Example of usage on the server:
     *
     * <pre>{@code
     * private static final DistributedContextManager contextManager =
     *     OpenTelemetry.getDistributedContextManager();
     * private static final HttpTextFormat textFormat = contextManager.getHttpTextFormat();
     * private static final HttpTextFormat.Getter<HttpRequest> getter = ...;
     *
     * void onRequestReceived(HttpRequest request) {
     *   DistributedContext distContext = textFormat.extract(request, getter);
     *   try (Scope s = contextManager.withContext(distContext)) {
     *     // Handle request and send response back.
     *   }
     * }
     * }</pre>
     *
     * @return the {@code HttpTextFormat} for this implementation.
     * @since 0.1.0
     */
    func getHttpTextFormat() -> TextFormattable
}
