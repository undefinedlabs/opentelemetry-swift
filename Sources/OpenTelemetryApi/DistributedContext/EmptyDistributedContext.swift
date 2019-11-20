//
//  EmptyDistributedContext.swift
//
//  Created by Ignacio Bonafonte on 14/11/2019.
//

import Foundation

/// An immutable implementation of the DistributedContext that does not contain any entries.
public class EmptyDistributedContext: DistributedContext {
    /// Returns the single instance of the EmptyDistributedContext class.
    public static var instance = EmptyDistributedContext()

    public static func contextBuilder() -> DistributedContextBuilder {
        return EmptyDistributedContextBuilder()
    }

    private init() {}

    public func getEntries() -> [Entry] {
        return [Entry]()
    }

    public func getEntryValue(key: EntryKey) -> EntryValue? {
        return nil
    }
}
