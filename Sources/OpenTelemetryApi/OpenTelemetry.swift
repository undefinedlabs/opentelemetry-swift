//
//  OpenTelemetry.swift
//
//  Created by Ignacio Bonafonte on 05/11/2019.
//

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
    public private(set)  var distributedContextManager: DistributedContextManager

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
