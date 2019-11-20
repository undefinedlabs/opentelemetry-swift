//
//  DistributedContextBuilder.swift
//
//
//  Created by Ignacio Bonafonte on 20/11/2019.
//

import Foundation

/// Builder for the DistributedContext class
public protocol DistributedContextBuilder: AnyObject {
    ///  Sets the parent {@link DistributedContext} to use. If no parent is provided, the value of
    ///  DistributedContextManager.getCurrentContext() at build() time will be used
    ///  as parent, unless {@link #setNoParent()} was called.
    ///  This must be used to create a {DistributedContext when manual Context
    ///  propagation is used.
    ///  If called multiple times, only the last specified value will be used.
    /// - Parameter parent: the DistributedContext used as parent
    @discardableResult func setParent(_ parent: DistributedContext) -> Self

    /// Sets the option to become a root DistributedContext with no parent. If not
    /// called, the value provided using setParent(DistributedContext) or otherwise
    /// DistributedContextManager.getCurrentContext()} at build() time will be used as
    /// parent.
    @discardableResult func setNoParent() -> Self

    /// Adds the key/value pair and metadata regardless of whether the key is present.
    /// - Parameters:
    ///   - key: the EntryKey which will be set.
    ///   - value: the EntryValue to set for the given key.
    ///   - metadata: the EntryMetadata associated with this Entry.
    @discardableResult func put(key: EntryKey, value: EntryValue, metadata: EntryMetadata) -> Self

    /// Removes the key if it exists.
    /// - Parameter key: the EntryKey which will be removed.
    @discardableResult func remove(key: EntryKey) -> Self

    /// Creates a DistributedContext from this builder.
    func build() -> DistributedContext
}
