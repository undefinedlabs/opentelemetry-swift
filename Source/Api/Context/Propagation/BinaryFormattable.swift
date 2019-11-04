//
//  BinaryFormattable.swift
//
//
//  Created by Ignacio Bonafonte on 15/10/2019.
//

import Foundation

public protocol BinaryFormattable {
    /// <summary>
    /// Deserializes span context from the bytes array.
    /// </summary>
    /// <param name="bytes">Bytes array with the envoded span context in it.</param>
    /// <returns>Span context deserialized from the byte array.</returns>
    func fromByteArray(bytes: [UInt8]) -> SpanContext?


    /// <summary>
    /// Serialize span context into the bytes array.
    /// </summary>
    /// <param name="spanContext">Span context to serialize.</param>
    /// <returns>Byte array with the encoded span context in it.</returns>
    func toByteArray(spanContext: SpanContext) -> [UInt8]
}
