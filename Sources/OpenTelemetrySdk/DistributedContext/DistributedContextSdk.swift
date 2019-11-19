//
//  DistributedContextSdk.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 14/11/2019.
//

import Foundation
import OpenTelemetryApi

class DistributedContextSdk: DistributedContext, Equatable {
    // The types of the EntryKey and Entry must match for each entry.
    var entries: [EntryKey: Entry?]
    var parent: DistributedContextSdk?

    /**
     * Creates a new {@link DistributedContextSdk} with the given entries.
     *
     * @param entries the initial entries for this {@code DistributedContextSdk}.
     * @param parent providing a default set of entries
     */
    fileprivate init(entries: [EntryKey: Entry?], parent: DistributedContextSdk?) {
        self.entries = entries
        self.parent = parent
    }

    static func contextBuilder() -> DistributedContextBuilder {
        return DistributedContextSdkBuilder()
    }

    func getEntries() -> [Entry] {
        var combined = entries
        if let parent = parent {
            for entry in parent.getEntries() {
                if combined[entry.key] == nil {
                    combined[entry.key] = entry
                }
            }
        }
        return Array(combined.values).compactMap { $0 }
    }

    func getEntryValue(key: EntryKey) -> EntryValue? {
        return entries[key]??.value ?? parent?.getEntryValue(key: key)
    }


    static func == (lhs: DistributedContextSdk, rhs: DistributedContextSdk) -> Bool {
        return lhs.parent == rhs.parent && lhs.entries == rhs.entries
    }
}

class DistributedContextSdkBuilder: DistributedContextBuilder {
    var parent: DistributedContext?
    var noImplicitParent: Bool = false
    var entries = [EntryKey: Entry?]()

    @discardableResult func setParent(_ parent: DistributedContext) -> Self {
        self.parent = parent
        return self
    }

    @discardableResult func setNoParent() -> Self {
        parent = nil
        noImplicitParent = true
        return self
    }

    @discardableResult func put(key: EntryKey, value: EntryValue, metadata: EntryMetadata) -> Self {
        let entry = Entry(key: key, value: value, entryMetadata: metadata)
        entries[key] = entry
        return self
    }

    @discardableResult func remove(key: EntryKey) -> Self {
        entries[key] = nil
        if parent?.getEntryValue(key: key) != nil {
            entries.updateValue(nil, forKey: key)
        }
        return self
    }

    func build() -> DistributedContext {
        var parentCopy = parent
        if parent == nil && !noImplicitParent {
            parentCopy = OpenTelemetry.instance.distributedContextManager.getCurrentContext()
        }
        return DistributedContextSdk(entries: entries, parent: parentCopy as? DistributedContextSdk)
    }
}
