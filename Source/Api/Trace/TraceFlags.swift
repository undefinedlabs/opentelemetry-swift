//
//  TraceFlags.swift
//
//
//  Created by Ignacio Bonafonte on 14/10/2019.
//

import Foundation

public struct TraceFlags: Equatable, CustomStringConvertible {
    // Default options. Nothing set.
    private static let DEFAULT_OPTIONS: UInt8 = 0
    // Bit to represent whether trace is sampled or not.
    private static let IS_SAMPLED: UInt8 = 0x1

    private static let SIZE = 1
    private static let BASE16_SIZE = 2 * SIZE
    private static let DEFAULT = TraceFlags(options: DEFAULT_OPTIONS)

    // The set of enabled features is determined by all the enabled bits.
    private var options: UInt8 = 0

    public init() {
    }

    // Creates a new {@code TraceFlags} with the given options.
    private init(options: UInt8) {
        self.options = options
    }

    /**
     * Returns the size in bytes of the {@code TraceFlags}.
     *
     * @return the size in bytes of the {@code TraceFlags}.
     * @since 0.1.0
     */
    static var size: Int {
        return SIZE
    }

    /**
     * Returns a {@code TraceFlags} whose representation is {@code src}.
     *
     * @param src the byte representation of the {@code TraceFlags}.
     * @return a {@code TraceFlags} whose representation is {@code src}.
     * @since 0.1.0
     */
    init(fromByte src: UInt8) {
        self.init(options: src)
    }

    //  /**
    //   * Returns a {@code TraceOption} built from a lowercase base16 representation.
    //   *
    //   * @param src the lowercase base16 representation.
    //   * @param srcOffset the offset in the buffer where the representation of the {@code TraceFlags}
    //   *     begins.
    //   * @return a {@code TraceOption} built from a lowercase base16 representation.
    //   * @throws NullPointerException if {@code src} is null.
    //   * @throws IllegalArgumentException if {@code src.length} is not {@code 2 * TraceOption.SIZE} OR
    //   *     if the {@code str} has invalid characters.
    //   * @since 0.1.0
    //   */
    //  public static TraceFlags fromLowerBase16(CharSequence src, int srcOffset) {
//    return new TraceFlags(BigendianEncoding.byteFromBase16String(src, srcOffset));
    //  }
    init(fromHexString hex: String, withOffset offset: Int = 0) {
        let firstIndex = hex.index(hex.startIndex, offsetBy: offset)
        let secondIndex = hex.index(firstIndex, offsetBy: 2)
        guard hex.count >= 2 + offset,
            let byte = UInt8(hex[firstIndex ..< secondIndex], radix: 16) else {
            self.init()
            return
        }
        self.init(fromByte: byte)
    }

    /**
     * Returns the one byte representation of the {@code TraceFlags}.
     *
     * @return the one byte representation of the {@code TraceFlags}.
     * @since 0.1.0
     */
    var byte: UInt8 {
        return options
    }

//    /**
//     * Copies the byte representations of the {@code TraceFlags} into the {@code dest} beginning at
//     * the {@code destOffset} offset.
//     *
//     * <p>Equivalent with (but faster because it avoids any new allocations):
//     *
//     * <pre>{@code
//     * System.arraycopy(getBytes(), 0, dest, destOffset, TraceFlags.getSize());
//     * }</pre>
//     *
//     * @param dest the destination buffer.
//     * @param destOffset the starting offset in the destination buffer.
//     * @throws NullPointerException if {@code dest} is null.
//     * @throws IndexOutOfBoundsException if {@code destOffset+TraceFlags.getSize()} is greater than
//     *     {@code dest.length}.
//     * @since 0.1.0
//     */
//    public void copyBytesTo(byte[] dest, int destOffset) {
//        Utils.checkIndex(destOffset, dest.length)
//        dest[destOffset] = options
//    }
//
//    /**
//     * Copies the lowercase base16 representations of the {@code TraceId} into the {@code dest}
//     * beginning at the {@code destOffset} offset.
//     *
//     * @param dest the destination buffer.
//     * @param destOffset the starting offset in the destination buffer.
//     * @throws IndexOutOfBoundsException if {@code destOffset + 2} is greater than {@code
//     *     dest.length}.
//     * @since 0.1.0
//     */
//    public void copyLowerBase16To(char[] dest, int destOffset) {
//        BigendianEncoding.byteToBase16String(options, dest, destOffset)
//    }
//
//    /**
//     * Returns the lowercase base16 encoding of this {@code TraceFlags}.
//     *
//     * @return the lowercase base16 encoding of this {@code TraceFlags}.
//     * @since 0.1.0
//     */
    public var hexString: String {
        return String(format: "%02x", options)
    }

//
//    /**
//     * Returns a new {@link Builder} with default options.
//     *
//     * @return a new {@code Builder} with default options.
//     * @since 0.1.0
//     */
//    public static Builder builder {
//        new Builder(DEFAULT_OPTIONS)
//    }
//
//    /**
//     * Returns a new {@link Builder} with all given options set.
//     *
//     * @param traceFlags the given options set.
//     * @return a new {@code Builder} with all given options set.
//     * @since 0.1.0
//     */
//    public static Builder builder(TraceFlags traceFlags) {
//        new Builder(traceFlags.options)
//    }

    /**
     * Returns a boolean indicating whether this {@code Span} is part of a sampled trace and data
     * should be exported to a persistent store.
     *
     * @return a boolean indicating whether the trace is sampled.
     * @since 0.1.0
     */
    public var isSampled: Bool {
        hasOption(mask: TraceFlags.IS_SAMPLED)
    }

    public mutating func setIsSampled(_ isSampled: Bool) {
        if isSampled {
            options = (options | TraceFlags.IS_SAMPLED)
        } else {
            options = (options & ~TraceFlags.IS_SAMPLED)
        }
    }

    public func settingIsSampled(_ isSampled: Bool) -> TraceFlags {
        var optionsCopy: UInt8
        if isSampled {
            optionsCopy = (options | TraceFlags.IS_SAMPLED)
        } else {
            optionsCopy = (options & ~TraceFlags.IS_SAMPLED)
        }
        return TraceFlags(options: optionsCopy)
    }

    public var description: String {
        "TraceFlags{sampled=\(isSampled)}"
    }

    private func hasOption(mask: UInt8) -> Bool {
        return (options & mask) != 0
    }
}
