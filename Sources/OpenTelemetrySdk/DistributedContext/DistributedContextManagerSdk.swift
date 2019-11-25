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
