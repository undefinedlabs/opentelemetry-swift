//
//  TraceId.swift
//
//
//  Created by Ignacio Bonafonte on 14/10/2019.
//

import Foundation

public struct TraceId: Comparable, Hashable, CustomStringConvertible, Equatable {
    private static let SIZE = 16
    // private static let BASE16_SIZE = 2 * BigendianEncoding.LONG_BASE16;
    private static let INVALID_ID: UInt64 = 0
    private static let INVALID = TraceId()

    // The internal representation of the TraceId.
    var idHi: UInt64 = INVALID_ID
    var idLo: UInt64 = INVALID_ID

    public init() {
    }

    /**
     * Constructs a {@code TraceId} whose representation is specified by two long values representing
     * the lower and higher parts.
     *
     * <p>There is no restriction on the specified values, other than the already established validity
     * rules applying to {@code TraceId}. Specifying 0 for both values will effectively make the new
     * {@code TraceId} invalid.
     *
     * <p>This is equivalent to calling {@link #fromBytes(byte[], int)} with the specified values
     * stored as big-endian.
     *
     * @param idHi the higher part of the {@code TraceId}.
     * @param idLo the lower part of the {@code TraceId}.
     * @since 0.1.0
     */
    public init(idHi: UInt64, idLo: UInt64) {
        self.idHi = idHi
        self.idLo = idLo
    }

    /**
     * Returns the size in bytes of the {@code TraceId}.
     *
     * @return the size in bytes of the {@code TraceId}.
     * @since 0.1.0
     */
    public static var size: Int {
        return SIZE
    }

    /**
     * Returns the invalid {@code TraceId}. All bytes are '\0'.
     *
     * @return the invalid {@code TraceId}.
     * @since 0.1.0
     */
    public static var invalid: TraceId {
        return INVALID
    }

    /**
     * Generates a new random {@code TraceId}.
     *
     * @param random the random number generator.
     * @return a new valid {@code TraceId}.
     */
    public static func random() -> TraceId {
        var idHi: UInt64
        var idLo: UInt64
        repeat {
            idHi = UInt64.random(in: .min ... .max)
            idLo = UInt64.random(in: .min ... .max)
        } while idHi == TraceId.INVALID_ID && idLo == TraceId.INVALID_ID
        return TraceId(idHi: idHi, idLo: idLo)
    }

    /**
     * Returns a {@code TraceId} whose representation is copied from the {@code src} beginning at the
     * {@code srcOffset} offset.
     *
     * @param src the buffer where the representation of the {@code TraceId} is copied.
     * @param srcOffset the offset in the buffer where the representation of the {@code TraceId}
     *     begins.
     * @return a {@code TraceId} whose representation is copied from the buffer.
     * @throws NullPointerException if {@code src} is null.
     * @throws IndexOutOfBoundsException if {@code srcOffset+TraceId.getSize()} is greater than {@code
     *     src.length}.
     * @since 0.1.0
     */
    public init(fromData data: Data) {
        var idHi: UInt64 = 0
        var idLo: UInt64 = 0
        data.withUnsafeBytes { rawPointer -> Void in
            idHi = rawPointer.load(fromByteOffset: data.startIndex, as: UInt64.self).bigEndian
            idLo = rawPointer.load(fromByteOffset: data.startIndex + MemoryLayout<UInt64>.size, as: UInt64.self).bigEndian
        }
        self.init(idHi: idHi, idLo: idLo)
    }

    public init(fromBytes bytes: Array<UInt8>) {
        self.init(fromData: Data(bytes))
    }

    public init(fromBytes bytes: ArraySlice<UInt8>) {
        self.init(fromData: Data(bytes))
    }

    public init(fromBytes bytes: ArraySlice<Character>) {
        self.init(fromData: Data(String(bytes).utf8.map { UInt8($0) }))
    }

    /**
     * Copies the byte array representations of the {@code TraceId} into the {@code dest} beginning at
     * the {@code destOffset} offset.
     *
     * @param dest the destination buffer.
     * @param destOffset the starting offset in the destination buffer.
     * @throws NullPointerException if {@code dest} is null.
     * @throws IndexOutOfBoundsException if {@code destOffset+TraceId.getSize()} is greater than
     *     {@code dest.length}.
     * @since 0.1.0
     */

    public func copyBytesTo(dest: inout Data, destOffset: Int) {
        dest.replaceSubrange(destOffset ..< destOffset + MemoryLayout<UInt64>.size, with: withUnsafeBytes(of: idHi.bigEndian) { Array($0) })
        dest.replaceSubrange(destOffset + MemoryLayout<UInt64>.size ..< destOffset + MemoryLayout<UInt64>.size * 2, with: withUnsafeBytes(of: idLo.bigEndian) { Array($0) })
    }

    public func copyBytesTo(dest: inout Array<UInt8>, destOffset: Int) {
        dest.replaceSubrange(destOffset ..< destOffset + MemoryLayout<UInt64>.size, with: withUnsafeBytes(of: idHi.bigEndian) { Array($0) })
        dest.replaceSubrange(destOffset + MemoryLayout<UInt64>.size ..< destOffset + MemoryLayout<UInt64>.size * 2, with: withUnsafeBytes(of: idLo.bigEndian) { Array($0) })
    }

    public func copyBytesTo(dest: inout ArraySlice<UInt8>, destOffset: Int) {
        dest.replaceSubrange(destOffset ..< destOffset + MemoryLayout<UInt64>.size, with: withUnsafeBytes(of: idHi.bigEndian) { Array($0) })
        dest.replaceSubrange(destOffset + MemoryLayout<UInt64>.size ..< destOffset + MemoryLayout<UInt64>.size * 2, with: withUnsafeBytes(of: idLo.bigEndian) { Array($0) })
    }

    /**
     * Returns a {@code TraceId} built from a lowercase base16 representation.
     *
     * @param src the lowercase base16 representation.
     * @param srcOffset the offset in the buffer where the representation of the {@code TraceId}
     *     begins.
     * @return a {@code TraceId} built from a lowercase base16 representation.
     * @throws NullPointerException if {@code src} is null.
     * @throws IllegalArgumentException if not enough characters in the {@code src} from the {@code
     *     srcOffset}.
     * @since 0.1.0
     */
    public init(fromHexString hex: String, withOffset offset: Int = 0) {
        let firstIndex = hex.index(hex.startIndex, offsetBy: offset)
        let secondIndex = hex.index(firstIndex, offsetBy: 16)
        let thirdIndex = hex.index(secondIndex, offsetBy: 16)

        guard hex.count >= 32 + offset,
            let idHi = UInt64(hex[firstIndex ..< secondIndex], radix: 16),
            let idLo = UInt64(hex[secondIndex ..< thirdIndex], radix: 16) else {
            self.init()
            return
        }
        self.init(idHi: idHi, idLo: idLo)
    }

    /**
     * Returns whether the {@code TraceId} is valid. A valid trace identifier is a 16-byte array with
     * at least one non-zero byte.
     *
     * @return {@code true} if the {@code TraceId} is valid.
     * @since 0.1.0
     */
    public var isValid: Bool {
        return idHi != TraceId.INVALID_ID || idLo != TraceId.INVALID_ID
    }

//
    //  /**
    //   * Returns the lowercase base16 encoding of this {@code TraceId}.
    //   *
    //   * @return the lowercase base16 encoding of this {@code TraceId}.
    //   * @since 0.1.0
    //   */
    public var hexString: String {
        return String(format: "%016llx%016llx", idHi, idLo)
    }

    /**
     * Returns the lower 8 bytes of the trace-id as a long value, assuming little-endian order. This
     * is used in ProbabilitySampler.
     *
     * <p>This method is marked as internal and subject to change.
     *
     * @return the lower 8 bytes of the trace-id as a long value, assuming little-endian order.
     */
    public var lowerLong: UInt64 {
        return idHi
    }

    public var description: String {
        return "TraceId{traceId=\(hexString)}"
    }

    public static func < (lhs: TraceId, rhs: TraceId) -> Bool {
        if lhs.idHi < rhs.idHi {
            return true
        } else if lhs.idHi == rhs.idHi && lhs.idLo < rhs.idLo {
            return true
        } else {
            return false
        }
    }

    public static func == (lhs: TraceId, rhs: TraceId) -> Bool {
        return lhs.idHi == rhs.idHi && lhs.idLo == rhs.idLo
    }
}
