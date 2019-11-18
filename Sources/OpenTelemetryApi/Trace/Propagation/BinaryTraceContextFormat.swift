//
//  BinaryTraceContextFormat.swift
//
//
//  Created by Ignacio Bonafonte on 16/10/2019.
//

import Foundation

enum SpanContextParseError: Error {
    case UnsupportedVersion
}

public struct BinaryTraceContextFormat: BinaryFormattable {
    private static let versionId: UInt8 = 0
    private static let versionIdOffset: Int = 0
    private static let traceIdSize: Int = 16
    private static let spanIdSize: Int = 8
    private static let traceOptionsSize: Int = 1

    // The version_id/field_id size in bytes.
    private static let idSize: Int = 1
    private static let traceIdFieldId: UInt8 = 0
    private static let traceIdFieldIdOffset: Int = versionIdOffset + idSize
    private static let traceIdOffset: Int = traceIdFieldIdOffset + idSize
    private static let spanIdFieldId: UInt8 = 1
    private static let spanIdFieldIdOffset: Int = traceIdOffset + traceIdSize
    private static let spanIdOffset: Int = spanIdFieldIdOffset + idSize
    private static let traceOptionsFieldId: UInt8 = 2
    private static let traceOptionFieldIdOffset: Int = spanIdOffset + spanIdSize
    private static let traceOptionOffset: Int = traceOptionFieldIdOffset + idSize
    private static let requiredFormatLength = 3 * idSize + traceIdSize + spanIdSize
    private static let allFormatLength: Int = requiredFormatLength + idSize + traceOptionsSize

//    public static func fromData(data: Data) throws -> SpanContext {
//
//        try data.withUnsafeBytes { rawPointer -> SpanContext in
//            if rawPointer.load(as: UInt8.self) != BinaryTraceContextFormat.VersionId {
//                throw SpanContextParseError.UnsupportedVersion
//            }
//            var traceId = TraceId.invalid;
//            var pos = 1
//            if rawPointer.load(fromByteOffset: pos, as: UInt8.self) == BinaryTraceContextFormat.TraceIdFieldId {
//                traceId = TraceId(fromData: data[0...4))
//            }
//
//        }
//
//    }

    public init() {}

    public func fromByteArray(bytes: [UInt8]) -> SpanContext? {
        if bytes.count == 0 || bytes[0] != BinaryTraceContextFormat.versionId || bytes.count < BinaryTraceContextFormat.requiredFormatLength {
            return nil
        }

        var traceId = TraceId.invalid
        var spanId = SpanId.invalid
        var traceOptions = TraceFlags()
        var pos = 1

        if bytes.count >= pos + BinaryTraceContextFormat.idSize + BinaryTraceContextFormat.traceIdSize,
            bytes[pos] == BinaryTraceContextFormat.traceIdFieldId {
            traceId = TraceId(fromBytes: bytes[(pos + BinaryTraceContextFormat.idSize)...])
            pos += BinaryTraceContextFormat.idSize + BinaryTraceContextFormat.traceIdSize
        } else {
            return nil
        }

        if bytes.count >= pos + BinaryTraceContextFormat.idSize + BinaryTraceContextFormat.spanIdSize,
            bytes[pos] == BinaryTraceContextFormat.spanIdFieldId {
            spanId = SpanId(fromBytes: bytes[(pos + BinaryTraceContextFormat.idSize)...])
            pos += BinaryTraceContextFormat.idSize + BinaryTraceContextFormat.spanIdSize
        } else {
            return nil
        }

        if bytes.count >= pos + BinaryTraceContextFormat.idSize,
            bytes[pos] == BinaryTraceContextFormat.traceOptionsFieldId {
            if bytes.count < BinaryTraceContextFormat.allFormatLength {
                return nil
            }
            traceOptions = TraceFlags(fromByte: bytes[pos + BinaryTraceContextFormat.idSize])
        }

        return SpanContext(traceId: traceId, spanId: spanId, traceFlags: traceOptions)
    }

    public func toByteArray(spanContext: SpanContext) -> [UInt8] {
        var byteArray = [UInt8](repeating: 0, count: BinaryTraceContextFormat.allFormatLength)
        byteArray[BinaryTraceContextFormat.versionIdOffset] = BinaryTraceContextFormat.versionId
        byteArray[BinaryTraceContextFormat.traceIdFieldIdOffset] = BinaryTraceContextFormat.traceIdFieldId
        byteArray[BinaryTraceContextFormat.spanIdFieldIdOffset] = BinaryTraceContextFormat.spanIdFieldId
        byteArray[BinaryTraceContextFormat.traceOptionFieldIdOffset] = BinaryTraceContextFormat.traceOptionsFieldId
        byteArray[BinaryTraceContextFormat.traceOptionOffset] = spanContext.traceFlags.byte
        spanContext.traceId.copyBytesTo(dest: &byteArray, destOffset: BinaryTraceContextFormat.traceIdOffset)
        spanContext.spanId.copyBytesTo(dest: &byteArray, destOffset: BinaryTraceContextFormat.spanIdOffset)
        return byteArray
    }
}
