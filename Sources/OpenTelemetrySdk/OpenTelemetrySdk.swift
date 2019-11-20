//
//  OpenTelemetrySdk.swift
//
//  Created by Ignacio Bonafonte on 05/11/2019.
//

import Foundation
import OpenTelemetryApi

class OpenTelemetrySDK {

    public static var tracerFactory: TracerSdkFactory {
        return OpenTelemetry.instance.tracerFactory as! TracerSdkFactory
    }

    /**
     * Returns a {@link MeterSdk}.
     *
     * @return meter returned by {@link OpenTelemetry#getMeter()}.
     * @since 0.1.0
     */
//    public static var meter: MeterSdkFactory  {
//            return OpenTelemetry.instance.meterFactory as! MeterSdkFactory//
//    }

    /**
     * Returns a {@link DistributedContextManagerSdk}.
     *
     * @return context manager returned by {@link OpenTelemetry#getDistributedContextManager()}.
     * @since 0.1.0
     */
    public static var distributedContextManager: DistributedContextManagerSdk {
      return OpenTelemetry.instance.distributedContextManager as! DistributedContextManagerSdk
    }
}
