//
//  Tracestate.swift
//
//
//  Created by Ignacio Bonafonte on 14/10/2019.
//

import Foundation
/**
 * Carries tracing-system specific context in a list of key-value pairs. TraceState allows different
 * vendors propagate additional information and inter-operate with their legacy Id formats.
 *
 * Implementation is optimized for a small list of key-value pairs.
 *
 * Key is opaque string up to 256 characters printable. It MUST begin with a lowercase letter,
 * and can only contain lowercase letters a-z, digits 0-9, underscores _, dashes -, asterisks *, and
 * forward slashes /.
 *
 * Value is opaque string up to 256 characters printable ASCII RFC0020 characters (i.e., the
 * range 0x20 to 0x7E) except comma , and =.
 *
 * @since 0.1.0
 */
public struct Tracestate: Equatable {
    private static let MAX_KEY_VALUE_PAIRS = 32

    private(set) var entries = [Entry]()

    public init() {
    }

    init?(entries: [Entry]) {
        guard entries.count <= Tracestate.MAX_KEY_VALUE_PAIRS else { return nil }

        self.entries = entries
    }

    /**
     * Returns the value to which the specified key is mapped, or null if this map contains no mapping
     * for the key.
     *
     * @param key with which the specified value is to be associated
     * @return the value to which the specified key is mapped, or null if this map contains no mapping
     *     for the key.
     * @since 0.1.0
     */
    public func get(key: String) -> String? {
        return entries.first(where: { $0.key == key })?.value
    }

    public mutating func set(key: String, value: String) {
        // Initially create the Entry to validate input.
        guard let entry = Entry(key: key, value: value) else { return }
        if entries.contains(where: { $0.key == entry.key }) {
            remove(key: entry.key)
        }
        entries.append(entry)
    }

    public func setting(key: String, value: String) -> Self {
        // Initially create the Entry to validate input.
        var newTracestate = self
        newTracestate.set(key: key, value: value)
        return newTracestate
    }

    /**
     * Removes the {@code Entry} that has the given {@code key} if it is present.
     *
     * @param key the key for the {@code Entry} to be removed.
     * @return this.
     * @since 0.1.0
     */
    public mutating func remove(key: String) {
        if let index = entries.firstIndex(where: { $0.key == key }) {
            entries.remove(at: index)
        }
    }

    public func removing(key: String) -> Tracestate {
        // Initially create the Entry to validate input.
        var newTracestate = self
        newTracestate.remove(key: key)
        return newTracestate
    }

    /**
     * Immutable key-value pair for {@code Tracestate}.
     *
     * @since 0.1.0
     */
    public struct Entry: Equatable {
        var key: String
        var value: String
        /**
         * Creates a new {@code Entry} for the {@code Tracestate}.
         *
         * @param key the Entry's key.
         * @param value the Entry's value.
         * @return the new {@code Entry}.
         * @since 0.1.0
         */
        init?(key: String, value: String) {
            if TracestateUtils.validateKey(key: key) && TracestateUtils.validateValue(value: value) {
                self.key = key
                self.value = value
                return
            }
            return nil
        }

        /**
         * Returns the key {@code String}.
         *
         * @return the key {@code String}.
         * @since 0.1.0
         */
        public func getKey() -> String {
            return key
        }

        /**
         * Returns the value {@code String}.
         *
         * @return the value {@code String}.
         * @since 0.1.0
         */
        public func getValue() -> String {
            return value
        }
    }
}
