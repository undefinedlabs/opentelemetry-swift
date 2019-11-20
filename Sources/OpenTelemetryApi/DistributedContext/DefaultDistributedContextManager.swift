//
//  DefaultDistributedContextManager.swift
//
//  Created by Ignacio Bonafonte on 14/11/2019.
//

import Foundation

/// No-op implementations ofDistributedContextManager.
public class DefaultDistributedContextManager: DistributedContextManager {
    ///  Returns a DistributedContextManager singleton that is the default implementation for
    ///  DistributedContextManager.
    static var instance = DefaultDistributedContextManager()
    static var binaryFormat = BinaryTraceContextFormat()
    static var httpTextFormat = HttpTraceContextFormat()

    private init() {}

    public func contextBuilder() -> DistributedContextBuilder {
        return EmptyDistributedContextBuilder()
    }

    public func getCurrentContext() -> DistributedContext {
        ContextUtils.getCurrentDistributedContext() ?? EmptyDistributedContext.instance
    }

    public func withContext(distContext: DistributedContext) -> Scope {
        return ContextUtils.withDistributedContext(distContext)
    }

    public func getBinaryFormat() -> BinaryFormattable {
        return DefaultDistributedContextManager.binaryFormat
    }

    public func getHttpTextFormat() -> TextFormattable {
        return DefaultDistributedContextManager.httpTextFormat
    }
}
