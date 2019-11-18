//
//  DefaultDistributedContextManager.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 14/11/2019.
//

import Foundation

public class DefaultDistributedContextManager: DistributedContextManager {

    static var instance = DefaultDistributedContextManager()
    static var binaryFormat = BinaryTraceContextFormat()
    static var httpTextFormat = HttpTraceContextFormat()

    private init() {}

    public func contextBuilder() -> DistributedContextBuilder {
        return NoopDistributedContextBuilder()
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
