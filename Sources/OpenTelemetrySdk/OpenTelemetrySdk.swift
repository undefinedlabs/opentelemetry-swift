//
//  OpenTelemetrySdk.swift
//
//  Created by Ignacio Bonafonte on 05/11/2019.
//

import Foundation
import OpenTelemetryApi

/// This class provides a static global accessor for SDK telemetry objects TracerSdkFactory,
/// MeterSdkFactory DistributedContextManagerSdk.
/// This is a convenience class getting and casting the telemetry objects from OpenTelemetry.
class OpenTelemetrySDK {
    /// TracerFactory returned by OpenTelemetry.getTracerFactory().
    public static var tracerFactory: TracerSdkFactory {
        return OpenTelemetry.instance.tracerFactory as! TracerSdkFactory
    }

//    /// Meter returned by OpenTelemetry.getMeter().
//    public static var meter: MeterSdkFactory  {
//            return OpenTelemetry.instance.meterFactory as! MeterSdkFactory//
//    }

    /// Context manager returned by OpenTelemetry.getDistributedContextManager().
    public static var distributedContextManager: DistributedContextManagerSdk {
        return OpenTelemetry.instance.distributedContextManager as! DistributedContextManagerSdk
    }
}
