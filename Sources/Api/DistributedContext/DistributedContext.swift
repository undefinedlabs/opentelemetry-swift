//
//  DistributedContext.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 14/11/2019.
//

import Foundation

public protocol DistributedContext: AnyObject {
    static func contextBuilder() -> DistributedContextBuilder
    func getEntries() -> [Entry]
    func getEntryValue(key: EntryKey) -> EntryValue?
}

public protocol DistributedContextBuilder: AnyObject  {
    @discardableResult func setParent(_ parent: DistributedContext) -> Self
    @discardableResult func setNoParent() -> Self
    @discardableResult func put(key: EntryKey, value: EntryValue, metadata: EntryMetadata) -> Self
    @discardableResult func remove(key: EntryKey) -> Self
    func build() -> DistributedContext
}

public class NoopDistributedContextBuilder: DistributedContextBuilder {
    public func setParent(_ parent: DistributedContext) -> Self {
        return self
    }

    public func setNoParent() -> Self {
        return self
    }

    public func put(key: EntryKey, value: EntryValue, metadata: EntryMetadata) -> Self {
        return self
    }

    public func remove(key: EntryKey) -> Self {
        return self
    }

    public func build() -> DistributedContext {
        return EmptyDistributedContext.instance
    }

    public init() {}
}
