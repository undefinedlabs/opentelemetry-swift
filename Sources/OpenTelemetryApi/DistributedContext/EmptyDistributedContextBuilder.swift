//
//  EmptyDistributedContextBuilder.swift
//  
//
//  Created by Ignacio Bonafonte on 20/11/2019.
//

import Foundation

public class EmptyDistributedContextBuilder: DistributedContextBuilder {
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
