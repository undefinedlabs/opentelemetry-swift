//
//  Tracestate.swift
//
//  Created by Ignacio Bonafonte on 14/10/2019.
//

import Foundation

/// Carries tracing-system specific context in a list of key-value pairs. TraceState allows different
/// vendors propagate additional information and inter-operate with their legacy Id formats.
/// Implementation is optimized for a small list of key-value pairs.
/// Key is opaque string up to 256 characters printable. It MUST begin with a lowercase letter,
/// and can only contain lowercase letters a-z, digits 0-9, underscores _, dashes -, asterisks *, and
/// forward slashes /.
/// Value is opaque string up to 256 characters printable ASCII RFC0020 characters (i.e., the
/// range 0x20 to 0x7E) except comma , and =.
public struct Tracestate: Equatable {
    private static let maxKeyValuePairs = 32

    private(set) var entries = [Entry]()

    /// Returns the default with no entries.
    public init() {
    }

    init?(entries: [Entry]) {
        guard entries.count <= Tracestate.maxKeyValuePairs else { return nil }

        self.entries = entries
    }

    /// Returns the value to which the specified key is mapped, or null if this map contains no mapping
    ///  for the key
    /// - Parameter key: key with which the specified value is to be associated
    public func get(key: String) -> String? {
        return entries.first(where: { $0.key == key })?.value
    }

    /// Adds or updates the Entry that has the given key if it is present. The new Entry will always
    /// be added in the front of the list of entries.
    /// - Parameters:
    ///   - key: the key for the Entry to be added.
    ///   - value: the value for the Entry to be added.
    public mutating func set(key: String, value: String) {
        // Initially create the Entry to validate input.
        guard let entry = Entry(key: key, value: value) else { return }
        if entries.contains(where: { $0.key == entry.key }) {
            remove(key: entry.key)
        }
        entries.append(entry)
    }

    /// Returns a copy the tracestate by appending the Entry that has the given key if it is present.
    /// The new Entry will always be added in the front of the existing list of entries.
    /// - Parameters:
    ///   - key: the key for the Entry to be added.
    ///   - value: the value for the Entry to be added.
    public func setting(key: String, value: String) -> Self {
        // Initially create the Entry to validate input.
        var newTracestate = self
        newTracestate.set(key: key, value: value)
        return newTracestate
    }

    /// Removes the Entry that has the given key if it is present.
    /// - Parameter key: the key for the Entry to be removed.
    public mutating func remove(key: String) {
        if let index = entries.firstIndex(where: { $0.key == key }) {
            entries.remove(at: index)
        }
    }

    /// Returns a copy the tracestate by removinf the Entry that has the given key if it is present.
    /// - Parameter key: the key for the Entry to be removed.
    public func removing(key: String) -> Tracestate {
        // Initially create the Entry to validate input.
        var newTracestate = self
        newTracestate.remove(key: key)
        return newTracestate
    }

    /// Immutable key-value pair for Tracestate
    public struct Entry: Equatable {
        /// The key of the Entry
        public private(set) var key: String

        /// The value of the Entry
        public private(set) var value: String

        /// Creates a new Entry for the Tracestate.
        /// - Parameters:
        ///   - key: the Entry's key.
        ///   - value: the Entry's value.
        init?(key: String, value: String) {
            if TracestateUtils.validateKey(key: key) && TracestateUtils.validateValue(value: value) {
                self.key = key
                self.value = value
                return
            }
            return nil
        }
    }
}
