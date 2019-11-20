//
//  BinaryFormattable.swift
//
//  Created by Ignacio Bonafonte on 15/10/2019.
//

import Foundation

public protocol BinaryFormattable {
    /// Deserializes span context from the bytes array.
    /// - Parameter bytes: Bytes array with the envoded span context in it.
    func fromByteArray(bytes: [UInt8]) -> SpanContext?

    /// Serialize span context into an array of bytes.
    /// - Parameter spanContext: Span context to serialize.
    func toByteArray(spanContext: SpanContext) -> [UInt8]
}
