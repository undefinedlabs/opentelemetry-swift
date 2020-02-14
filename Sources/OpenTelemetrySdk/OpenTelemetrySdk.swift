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

/// This class provides a static global accessor for SDK telemetry objects TracerSdkFactory,
/// MeterSdkFactory CorrelationContextManagerSdk.
/// This is a convenience class getting and casting the telemetry objects from OpenTelemetry.
public struct OpenTelemetrySDK {
    public static var instance = OpenTelemetrySDK()

    /// TracerFactory returned by OpenTelemetry.getTracerFactory().
    public var tracerFactory: TracerSdkFactory {
        return OpenTelemetry.instance.tracerFactory as! TracerSdkFactory
    }

//    /// Meter returned by OpenTelemetry.getMeter().
//    public var meter: MeterSdkFactory  {
//            return OpenTelemetry.instance.meterFactory as! MeterSdkFactory//
//    }

    /// Context manager returned by OpenTelemetry.getCorrelationContextManager().
    public var distributedContextManager: CorrelationContextManagerSdk {
        return OpenTelemetry.instance.distributedContextManager as! CorrelationContextManagerSdk
    }

    private init() {
        OpenTelemetry.registerTracerFactory(tracerFactory: TracerSdkFactory())
        OpenTelemetry.registerCorrelationContextManager(distributedContextManager: CorrelationContextManagerSdk())
    }
}
