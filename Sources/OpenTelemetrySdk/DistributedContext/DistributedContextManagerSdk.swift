//
//  DistributedContextManagerSdk.swift
//
//  Created by Ignacio Bonafonte on 14/11/2019.
//

import Foundation
import OpenTelemetryApi

/// DistributedContextManagerSdk is SDK implementation of DistributedContextManager.
public class DistributedContextManagerSdk: DistributedContextManager {
    public func contextBuilder() -> DistributedContextBuilder {
        return DistributedContextSdkBuilder()
    }

    public func getCurrentContext() -> DistributedContext {
        return ContextUtils.getCurrentDistributedContext() ?? EmptyDistributedContext.instance
    }

    public func withContext(distContext: DistributedContext) -> Scope {
        return ContextUtils.withDistributedContext(distContext)
    }

    public func getBinaryFormat() -> BinaryFormattable {
        return BinaryTraceContextFormat()
    }

    public func getHttpTextFormat() -> TextFormattable {
        return HttpTraceContextFormat()
    }
}
