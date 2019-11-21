//
//  ReadableSpan.swift
//  Created by Ignacio Bonafonte on 04/11/2019.
//

import Foundation
import OpenTelemetryApi

/// The extend Span interface used by the SDK.
public protocol ReadableSpan: Span {
    /// The name of the Span.
    /// The name can be changed during the lifetime of the Span so this value cannot be cached.
    var name: String { get set }

    /// The instrumentation library specified when creating the tracer which produced this span.
    var instrumentationLibraryInfo: InstrumentationLibraryInfo { get }

    /// This converts this instance into an immutable SpanData instance, for use in export.
    func toSpanData() -> SpanData
}
