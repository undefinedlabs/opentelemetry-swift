//
//  BinaryFormat.swift
//
//
//  Created by Ignacio Bonafonte on 16/10/2019.
//

import Foundation

enum SpanContextParseError: Error {
    case UnsupportedVersion
}

public struct BinaryFormat: BinaryFormattable {
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
//            if rawPointer.load(as: UInt8.self) != BinaryFormat.VersionId {
//                throw SpanContextParseError.UnsupportedVersion
//            }
//            var traceId = TraceId.invalid;
//            var pos = 1
//            if rawPointer.load(fromByteOffset: pos, as: UInt8.self) == BinaryFormat.TraceIdFieldId {
//                traceId = TraceId(fromData: data[0...4))
//            }
//
//        }
//
//    }

    public func fromByteArray(bytes: [UInt8]) -> SpanContext? {
        if bytes.count == 0 || bytes[0] != BinaryFormat.versionId || bytes.count < BinaryFormat.requiredFormatLength {
            return nil
        }

        var traceId = TraceId.invalid
        var spanId = SpanId.invalid
        var traceOptions = TraceFlags()
        var pos = 1

        if bytes.count >= pos + BinaryFormat.idSize + BinaryFormat.traceIdSize,
            bytes[pos] == BinaryFormat.traceIdFieldId {
            traceId = TraceId(fromBytes: bytes[(pos + BinaryFormat.idSize)...])
            pos += BinaryFormat.idSize + BinaryFormat.traceIdSize
        } else {
            return nil
        }

        if bytes.count >= pos + BinaryFormat.idSize + BinaryFormat.spanIdSize,
            bytes[pos] == BinaryFormat.spanIdFieldId {
            spanId = SpanId(fromBytes: bytes[(pos + BinaryFormat.idSize)...])
            pos += BinaryFormat.idSize + BinaryFormat.spanIdSize
        } else {
            return nil
        }

        if bytes.count >= pos + BinaryFormat.idSize,
            bytes[pos] == BinaryFormat.traceOptionsFieldId {
            if bytes.count < BinaryFormat.allFormatLength {
                return nil
            }
            traceOptions = TraceFlags(fromByte: bytes[pos + BinaryFormat.idSize])
        }

        return SpanContext(traceId: traceId, spanId: spanId, traceFlags: traceOptions)
    }

    public func toByteArray(spanContext: SpanContext) -> [UInt8] {
        var byteArray = [UInt8](repeating: 0, count: BinaryFormat.allFormatLength)
        byteArray[BinaryFormat.versionIdOffset] = BinaryFormat.versionId
        byteArray[BinaryFormat.traceIdFieldIdOffset] = BinaryFormat.traceIdFieldId
        byteArray[BinaryFormat.spanIdFieldIdOffset] = BinaryFormat.spanIdFieldId
        byteArray[BinaryFormat.traceOptionFieldIdOffset] = BinaryFormat.traceOptionsFieldId
        byteArray[BinaryFormat.traceOptionOffset] = spanContext.traceFlags.byte
        spanContext.traceId.copyBytesTo(dest: &byteArray, destOffset: BinaryFormat.traceIdOffset)
        spanContext.spanId.copyBytesTo(dest: &byteArray, destOffset: BinaryFormat.spanIdOffset)
        return byteArray
    }
}
