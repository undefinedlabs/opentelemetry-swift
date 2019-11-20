//
//  LoggingBinaryFormat.swift
//
//
//  Created by Ignacio Bonafonte on 19/11/2019.
//

import Foundation
import OpenTelemetryApi

struct LoggingBinaryFormat: BinaryFormattable {
    func fromByteArray(bytes: [UInt8]) -> SpanContext? {
        Logger.log("LoggingBinaryFormat.FromByteArray(...)")
        return SpanContext.invalid
    }

    func toByteArray(spanContext: SpanContext) -> [UInt8] {
        Logger.log("LoggingBinaryFormat.ToByteArray({spanContext})")
        return [UInt8]()
    }
}
