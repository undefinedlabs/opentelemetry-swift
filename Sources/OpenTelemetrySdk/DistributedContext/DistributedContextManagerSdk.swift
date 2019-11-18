//
//  DistributedContextManagerSdk.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 14/11/2019.
//

import Foundation
import OpenTelemetryApi

class DistributedContextManagerSdk: DistributedContextManager {

    func contextBuilder() -> DistributedContextBuilder {
        return DistributedContextSdkBuilder()
    }


    func getCurrentContext() -> DistributedContext {
        return ContextUtils.getCurrentDistributedContext() ?? EmptyDistributedContext.instance
    }
    
    func withContext(distContext: DistributedContext) -> Scope {
        return ContextUtils.withDistributedContext(distContext)
    }

    func getBinaryFormat() -> BinaryFormattable {
        return BinaryTraceContextFormat()
    }

    func getHttpTextFormat() -> TextFormattable {
        return HttpTraceContextFormat()
    }
}
