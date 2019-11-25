/*
 * Copyright 2019, Undefined Labs
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

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
