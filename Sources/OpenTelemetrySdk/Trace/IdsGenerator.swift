//
//  IdsGenerator.swift
//  //
//  Created by Ignacio Bonafonte on 18/11/2019.
//

import Foundation
import OpenTelemetryApi

public protocol IdsGenerator {
    /**
     * Generates a new valid {@code SpanId}.
     *
     * @return a new valid {@code SpanId}.
     */
    func generateSpanId() -> SpanId;

    /**
     * Generates a new valid {@code TraceId}.
     *
     * @return a new valid {@code TraceId}.
     */
    func generateTraceId() -> TraceId

}
