//
//  DistributedContextManager.swift
//
//  Created by Ignacio Bonafonte on 14/11/2019.
//

import Foundation

/// Object for creating new DistributedContexts and DistributedContexts based on the
/// current context.
/// This class returns DistributedContext builders that can be used to create the
/// implementation-dependent DistributedContexts.
/// Implementations may have different constraints and are free to convert entry contexts to their
/// own subtypes. This means callers cannot assume the getCurrentContext()
/// is the same instance as the one withContext() placed into scope.
public protocol DistributedContextManager: AnyObject {
    /// Returns the current DistributedContext
    func getCurrentContext() -> DistributedContext

    /// Returns a new ContextBuilder.
    func contextBuilder() -> DistributedContextBuilder

    /// Enters the scope of code where the given DistributedContext is in the current context
    /// (replacing the previous DistributedContext) and returns an object that represents that
    /// scope. The scope is exited when the returned object is closed.
    /// - Parameter distContext: the DistributedContext to be set as the current context.
    func withContext(distContext: DistributedContext) -> Scope

    /// Returns the BinaryFormat for this implementation.
    func getBinaryFormat() -> BinaryFormattable

    /// Returns the HttpTextFormat for this implementation.
    func getHttpTextFormat() -> TextFormattable
}
