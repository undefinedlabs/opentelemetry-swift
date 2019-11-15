//
//  DistributedContext.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 14/11/2019.
//

import Foundation

protocol DistributedContext: AnyObject {
    static func contextBuilder() -> DistributedContextBuilder
    func getEntries() -> [Entry]
    func getEntryValue(key: EntryKey) -> EntryValue?
}

protocol DistributedContextBuilder: AnyObject  {
    @discardableResult func setParent(_ parent: DistributedContext) -> Self
    @discardableResult func setNoParent() -> Self
    @discardableResult func put(key: EntryKey, value: EntryValue, metadata: EntryMetadata) -> Self
    @discardableResult func remove(key: EntryKey) -> Self
    func build() -> DistributedContext
}

class NoopDistributedContextBuilder: DistributedContextBuilder {
    func setParent(_ parent: DistributedContext) -> Self {
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
