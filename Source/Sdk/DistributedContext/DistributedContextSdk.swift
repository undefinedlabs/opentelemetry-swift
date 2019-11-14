//
//  DistributedContextSdk.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 14/11/2019.
//

import Foundation

class DistributedContextSdk: DistributedContext, Equatable {
    // The types of the EntryKey and Entry must match for each entry.
    var entries: [EntryKey: Entry]
    var parent: DistributedContextSdk?
    var builder = DistributedContextSdkBuilder()

    /**
     * Creates a new {@link DistributedContextSdk} with the given entries.
     *
     * @param entries the initial entries for this {@code DistributedContextSdk}.
     * @param parent providing a default set of entries
     */
    fileprivate init(entries: [EntryKey: Entry], parent: DistributedContextSdk?) {
        self.entries = entries
        self.parent = parent
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
        return Array(combined.values)
    }

    func getEntryValue(key: EntryKey) -> EntryValue? {
        return entries[key]?.value ?? parent?.getEntryValue(key: key)
    }

    func getBuilder() -> DistributedContextBuilder {
        return builder
    }

    static func == (lhs: DistributedContextSdk, rhs: DistributedContextSdk) -> Bool {
        return lhs.parent == rhs.parent && lhs.entries == rhs.entries
    }
}

struct DistributedContextSdkBuilder: DistributedContextBuilder {
    var parent: DistributedContext?
    var noImplicitParent: Bool = false
    var entries = [EntryKey: Entry]()

    mutating func setParent(parent: DistributedContext) -> Self {
        self.parent = parent
        return self
    }

    mutating func setNoParent() -> Self {
        parent = nil
        noImplicitParent = true
        return self
    }

    mutating func put(key: EntryKey, value: EntryValue, metadata: EntryMetadata) -> Self {
        let entry = Entry(key: key, value: value, entryMetadata: metadata)
        entries[key] = entry
        return self
    }

    mutating func remove(key: EntryKey) -> Self {
        entries[key] = nil
        return self
    }

    mutating func build() -> DistributedContext {
        if parent == nil && !noImplicitParent {
            parent = OpenTelemetry.instance.contextManager.getCurrentContext()
        }
        return DistributedContextSdk(entries: entries, parent: parent as? DistributedContextSdk)
    }
}
