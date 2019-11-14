//
//  DistributedContext.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 14/11/2019.
//

import Foundation

protocol DistributedContext: AnyObject {
    func getEntries() -> [Entry]
    func getEntryValue(key: EntryKey) -> EntryValue?
    func getBuilder() -> DistributedContextBuilder
}

protocol DistributedContextBuilder {
    mutating func setParent(parent: DistributedContext) -> Self
    mutating func setNoParent() -> Self
    mutating func put(key: EntryKey, value: EntryValue, metadata: EntryMetadata) -> Self
    mutating func remove(key: EntryKey) -> Self
    mutating func build() -> DistributedContext
}

struct NoopDistributedContextBuilder: DistributedContextBuilder {
    func setParent(parent: DistributedContext) -> Self {
        return self
    }

    func setNoParent() -> Self {
        return self
    }

    func put(key: EntryKey, value: EntryValue, metadata: EntryMetadata) -> Self {
        return self
    }

    func remove(key: EntryKey) -> Self {
        return self
    }

    func build() -> DistributedContext {
        return EmptyDistributedContext.instance
    }
}
