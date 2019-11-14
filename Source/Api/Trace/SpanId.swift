//
//  SpanId.swift
//
//
//  Created by Ignacio Bonafonte on 14/10/2019.
//

import Foundation

/**
 * A class that represents a span identifier. A valid span identifier is an 8-byte array with at
 * least one non-zero byte.
 *
 * @since 0.1.0
 */
public struct SpanId: Equatable, Comparable, Hashable, CustomStringConvertible {
    private static let SIZE = 8
    private static let BASE16_SIZE = 2 * SIZE
    private static let INVALID_ID: UInt64 = 0
    private static let INVALID = SpanId(id: INVALID_ID)

    // The internal representation of the SpanId.
    var id: UInt64 = INVALID_ID

    public init() {
    }

    /**
     * Constructs a {@code SpanId} whose representation is specified by a long value.
     *
     * <p>There is no restriction on the specified value, other than the already established validity
     * rules applying to {@code SpanId}. Specifying 0 for this value will effectively make the new
     * {@code SpanId} invalid.
     *
     * <p>This is equivalent to calling {@link #fromBytes(byte[], int)} with the specified value
     * stored as big-endian.
     *
     * @param id the long representation of the {@code TraceId}.
     * @since 0.1.0
     */
    public init(id: UInt64) {
        self.id = id
    }

    /**
     * Returns the size in bytes of the {@code SpanId}.
     *
     * @return the size in bytes of the {@code SpanId}.
     * @since 0.1.0
     */
    public static var size: Int {
        return SIZE
    }

    /**
     * Returns the invalid {@code SpanId}. All bytes are 0.
     *
     * @return the invalid {@code SpanId}.
     * @since 0.1.0
     */
    public static var invalid: SpanId {
        return INVALID
    }

    /**
     * Generates a new random {@code SpanId}.
     *
     * @param random The random number generator.
     * @return a valid new {@code SpanId}.
     */
    static func random() -> SpanId {
        var id: UInt64
        repeat {
            id = UInt64.random(in: .min ... .max)
        } while id == INVALID_ID

        return SpanId(id: id)
    }

    /**
     * Returns a {@code SpanId} whose representation is copied from the {@code src} beginning at the
     * {@code srcOffset} offset.
     *
     * @param src the buffer where the representation of the {@code SpanId} is copied.
     * @param srcOffset the offset in the buffer where the representation of the {@code SpanId}
     *     begins.
     * @return a {@code SpanId} whose representation is copied from the buffer.
     * @throws NullPointerException if {@code src} is null.
     * @throws IndexOutOfBoundsException if {@code srcOffset+SpanId.getSize()} is greater than {@code
     *     src.length}.
     * @since 0.1.0
     */

    init(fromData data: Data, withOffset offset: Int = 0) {
        var id: UInt64 = 0
        data.withUnsafeBytes { rawPointer -> Void in
            id = rawPointer.load(fromByteOffset: data.startIndex + offset, as: UInt64.self).bigEndian
        }
        self.init(id: id)
    }

    init(fromBytes bytes: Array<UInt8>, withOffset offset: Int = 0) {
        self.init(fromData: Data(bytes), withOffset: offset)
    }

    init(fromBytes bytes: ArraySlice<UInt8>, withOffset offset: Int = 0) {
        self.init(fromData: Data(bytes), withOffset: offset)
    }

    init(fromBytes bytes: ArraySlice<Character>, withOffset offset: Int = 0) {
        self.init(fromData: Data(String(bytes).utf8.map { UInt8($0) }))
    }

    /**
     * Copies the byte array representations of the {@code SpanId} into the {@code dest} beginning at
     * the {@code destOffset} offset.
     *
     * @param dest the destination buffer.
     * @param destOffset the starting offset in the destination buffer.
     * @throws NullPointerException if {@code dest} is null.
     * @throws IndexOutOfBoundsException if {@code destOffset+SpanId.getSize()} is greater than {@code
     *     dest.length}.
     * @since 0.1.0
     */
//    public func copyBytesTo(dest: inout Slice<Data>, destOffset: Int) {
//        dest.withUnsafeMutableBytes { rawPointer -> Void in
//            rawPointer.storeBytes(of: id.bigEndian, toByteOffset: Int, as: UInt64)
//        }
//    }
    // RangeReplaceableCollection
    public func copyBytesTo(dest: inout Data, destOffset: Int) {
        dest.replaceSubrange(destOffset ..< destOffset + MemoryLayout<UInt64>.size, with: withUnsafeBytes(of: id.bigEndian) { Array($0) })
    }

    public func copyBytesTo(dest: inout Array<UInt8>, destOffset: Int) {
        dest.replaceSubrange(destOffset ..< destOffset + MemoryLayout<UInt64>.size, with: withUnsafeBytes(of: id.bigEndian) { Array($0) })
    }

    public func copyBytesTo(dest: inout ArraySlice<UInt8>, destOffset: Int) {
        dest.replaceSubrange(destOffset ..< destOffset + MemoryLayout<UInt64>.size, with: withUnsafeBytes(of: id.bigEndian) { Array($0) })
    }

    //  /**
    //   * Returns a {@code SpanId} built from a lowercase base16 representation.
    //   *
    //   * @param src the lowercase base16 representation.
    //   * @param srcOffset the offset in the buffer where the representation of the {@code SpanId}
    //   *     begins.
    //   * @return a {@code SpanId} built from a lowercase base16 representation.
    //   * @throws NullPointerException if {@code src} is null.
    //   * @throws IllegalArgumentException if not enough characters in the {@code src} from the {@code
    //   *     srcOffset}.
    //   * @since 0.1.0
    //   */
    init(fromHexString hex: String, withOffset offset: Int = 0) {
        let firstIndex = hex.index(hex.startIndex, offsetBy: offset)
        let secondIndex = hex.index(firstIndex, offsetBy: 16)

        guard hex.count >= 16 + offset,
            let id = UInt64(hex[firstIndex ..< secondIndex], radix: 16) else {
            self.init()
            return
        }
        self.init(id: id)
    }

    //  public static SpanId fromLowerBase16(CharSequence src, int srcOffset) {
//    Utils.checkNotNull(src, "src");
//    return new SpanId(BigendianEncoding.longFromBase16String(src, srcOffset));
    //  }
//
    //  /**
    //   * Copies the lowercase base16 representations of the {@code SpanId} into the {@code dest}
    //   * beginning at the {@code destOffset} offset.
    //   *
    //   * @param dest the destination buffer.
    //   * @param destOffset the starting offset in the destination buffer.
    //   * @throws IndexOutOfBoundsException if {@code destOffset + 2 * SpanId.getSize()} is greater than
    //   *     {@code dest.length}.
    //   * @since 0.1.0
    //   */
    //  public void copyLowerBase16To(char[] dest, int destOffset) {
//    BigendianEncoding.longToBase16String(id, dest, destOffset);
    //  }

    public var hexString: String {
        return String(format: "%016llx", id)
    }

    /**
     * Returns whether the span identifier is valid. A valid span identifier is an 8-byte array with
     * at least one non-zero byte.
     *
     * @return {@code true} if the span identifier is valid.
     * @since 0.1.0
     */
    public var isValid: Bool {
        return id != SpanId.INVALID_ID
    }

    //  /**
    //   * Returns the lowercase base16 encoding of this {@code SpanId}.
    //   *
    //   * @return the lowercase base16 encoding of this {@code SpanId}.
    //   * @since 0.1.0
    //   */
    //  public String toLowerBase16() {
//    char[] chars = new char[BASE16_SIZE];
//    copyLowerBase16To(chars, 0);
//    return new String(chars);
    //  }

    //  @Override
    //  public int hashCode() {
//    // Copied from Long.hashCode in java8.
//    return (int) (id ^ (id >>> 32));
    //  }

    public var description: String {
        // return "SpanId{spanId=" + toLowerBase16() + "}";
        return "SpanId{spanId=\(hexString)}"
    }

    public static func < (lhs: SpanId, rhs: SpanId) -> Bool {
        return lhs.id < rhs.id
    }

    public static func == (lhs: SpanId, rhs: SpanId) -> Bool {
        return lhs.id == rhs.id
    }
}
