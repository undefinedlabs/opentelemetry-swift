//
//  DistributedContext.swift
//
//  Created by Ignacio Bonafonte on 14/11/2019.
//

import Foundation

/// A map from EntryKey to EntryValue and EntryMetadata that can be used to
/// label anything that is associated with a specific operation.
/// For example, DistributedContexts can be used to label stats, log messages, or
/// debugging information.
public protocol DistributedContext: AnyObject {
    /// Builder for the DistributedContext class
    static func contextBuilder() -> DistributedContextBuilder

    /// Returns an immutable collection of the entries in this DistributedContext. Order of
    /// entries is not guaranteed.
    func getEntries() -> [Entry]

    ///  Returns the EntryValue associated with the given EntryKey.
    /// - Parameter key: entry key to return the value for.
    func getEntryValue(key: EntryKey) -> EntryValue?
}
