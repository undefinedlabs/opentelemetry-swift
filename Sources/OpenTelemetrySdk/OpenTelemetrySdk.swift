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

    /// Context manager returned by OpenTelemetry.getDistributedContextManager().
    public var distributedContextManager: DistributedContextManagerSdk {
        return OpenTelemetry.instance.distributedContextManager as! DistributedContextManagerSdk
    }

    private init(){
        OpenTelemetry.registerTracerFactory(tracerFactory: TracerSdkFactory())
        OpenTelemetry.registerDistributedContextManager(distributedContextManager: DistributedContextManagerSdk())
    }
}
