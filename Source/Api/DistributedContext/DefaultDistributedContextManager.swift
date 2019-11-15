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

    func contextBuilder() -> DistributedContextBuilder {
        return NoopDistributedContextBuilder()
    }


    func getCurrentContext() -> DistributedContext {
        ContextUtils.getCurrentDistributedContext() ?? EmptyDistributedContext.instance
    }

    func withContext(distContext: DistributedContext) -> Scope {
        return ContextUtils.withDistributedContext(distContext)
    }

    func getBinaryFormat() -> BinaryFormattable {
        return DefaultDistributedContextManager.binaryFormat
    }

    func getHttpTextFormat() -> TextFormattable {
        return DefaultDistributedContextManager.httpTextFormat
    }
}
