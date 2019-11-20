//
//  EntryMetadata.swift
//  Created by Ignacio Bonafonte on 14/11/2019.
//

import Foundation

/// EntryTtl is an an that represents number of hops an entry can propagate.
/// Anytime a sender serializes a entry, sends it over the wire and receiver deserializes the
/// entry then the entry is considered to have travelled one hop.
/// There could be one or more proxy(ies) between sender and receiver. Proxies are treated as
/// transparent entities and they are not counted as hops.
/// For now, only special values of {@link EntryTtl} are supported.
public enum EntryTtl: Equatable {
    /// An Entry with EntryTtl.noPropagation is considered to have local scope and
    /// is used within the process where it's created.
    case noPropagation

    /// NUmber of times a sender serializes an entry, sends it over the wireand receiver
    /// deserializes the entry
    case hops(Int)

    /// An {@link Entry} with {@link EntryTtl#UNLIMITED_PROPAGATION} can propagate unlimited hops.
    /// However, it is still subject to outgoing and incoming (on remote side) filter criteria.
    /// EntryTtl.unlimitedPropagation is typical used to track a request, which may be
    /// processed across multiple entities.
    case unlimitedPropagation
}

public struct EntryMetadata: Equatable {
    var entryTtl: EntryTtl

    public init(entryTtl: EntryTtl) {
        self.entryTtl = entryTtl
    }
}
