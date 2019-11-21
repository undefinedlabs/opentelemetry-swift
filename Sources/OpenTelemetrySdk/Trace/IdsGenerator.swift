//
//  IdsGenerator.swift
//  //
//  Created by Ignacio Bonafonte on 18/11/2019.
//

import Foundation
import OpenTelemetryApi

/// Interface that is used by the TracerSdk to generate new SpanId and TraceId.
public protocol IdsGenerator {
    /// Generates a new valid SpanId
    func generateSpanId() -> SpanId

    /// Generates a new valid TraceId.
    func generateTraceId() -> TraceId
}
