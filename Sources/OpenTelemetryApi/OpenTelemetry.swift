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

/// This class provides a static global accessor for telemetry objects Tracer, Meter
///  and DistributedContextManager.
///  The telemetry objects are lazy-loaded singletons resolved via ServiceLoader mechanism.
public struct OpenTelemetry {
    public static var instance = OpenTelemetry()

    /// Registered TracerFactory or default via DefaultTracerFactory.instance.
    public private(set) var tracerFactory: TracerFactory

//    /// Registered MeterFactory or default via DefaultMeterFactory.instance.
//    public private(set)  var meter: MeterFactory

    /// registered manager or default via  DefaultDistributedContextManager.instance.
    public private(set) var distributedContextManager: DistributedContextManager

    private init() {
        tracerFactory = DefaultTracerFactory.instance
//        meter = DefaultMeterFactory.instance;
        distributedContextManager = DefaultDistributedContextManager.instance
    }

    public static func registerTracerFactory(tracerFactory: TracerFactory) {
        instance.tracerFactory = tracerFactory
    }

    public static func registerDistributedContextManager(distributedContextManager: DistributedContextManager) {
        instance.distributedContextManager = distributedContextManager
    }
}
