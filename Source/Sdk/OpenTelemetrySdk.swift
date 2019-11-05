//
//  OpenTelemetrySdk.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 05/11/2019.
//

import Foundation

class OpenTelemetrySDK {

    public static var tracer: TracerSdk {
      return TracerSdk()
    }

    /**
     * Returns a {@link MeterSdk}.
     *
     * @return meter returned by {@link OpenTelemetry#getMeter()}.
     * @since 0.1.0
     */
//    public static var meter: MeterSdk  {
//      return MeterSdk()
//
//    }

    /**
     * Returns a {@link DistributedContextManagerSdk}.
     *
     * @return context manager returned by {@link OpenTelemetry#getDistributedContextManager()}.
     * @since 0.1.0
     */
//    public static var distributedContextManager: DistributedContextManagerSdk {
//      return DistributedContextManagerSdk()
//    }
}
