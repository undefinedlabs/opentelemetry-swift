//
//  ReadableSpan.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 04/11/2019.
//

import Foundation
import OpenTelemetryApi

/** The extend Span interface used by the SDK. */
public protocol ReadableSpan: Span {
    /**
     * Returns the {@link SpanContext} of the {@code Span}.
     *
     * <p>Equivalent with {@link Span#getContext()}.
     *
     * @return the {@link SpanContext} of the {@code Span}.
     * @since 0.1.0
     */
//    var spanContext: SpanContext { get }

    /**
     * Returns the name of the {@code Span}.
     *
     * <p>The name can be changed during the lifetime of the Span by using the {@link
     * Span#updateName(String)} so this value cannot be cached.
     *
     * @return the name of the {@code Span}.
     * @since 0.1.0
     */
    var name: String { get }

    /**
     * This converts this instance into an immutable SpanData instance, for use in export.
     *
     * @return an immutable {@link SpanData} instance.
     * @since 0.1.0
     */
    func toSpanData() -> SpanData
}
