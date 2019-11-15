//
//  Entry.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 14/11/2019.
//

import Foundation

public struct Entry: Equatable, Comparable {

    static let metadataUnlimitedPropagation = EntryMetadata(entryTtl: .unlimitedPropagation)

    public private(set) var key: EntryKey
    public private(set) var value: EntryValue
    public private(set) var metadata: EntryMetadata

    /**
     * Creates an {@code Entry} from the given key, value and metadata.
     *
     * @param key the entry key.
     * @param value the entry value.
     * @param entryMetadata the entry metadata.
     * @return a {@code Entry}.
     * @since 0.1.0
     */
    public init(key: EntryKey, value: EntryValue, entryMetadata: EntryMetadata) {
        self.key = key
        self.value = value
        metadata = entryMetadata
    }

    public static func < (lhs: Entry, rhs: Entry) -> Bool {
        return lhs.key < rhs.key
    }
}