//
//  OpenTelemetry.swift
//
//  Created by Ignacio Bonafonte on 05/11/2019.
//

import Foundation

public class OpenTelemetry {
    public typealias TracerFactory = AnyObject

    public static var instance = OpenTelemetry()

    public private(set) var tracerFactory: TracerFactory
//    private(set) var meter: MeterFactory
    public private(set) var distributedContextManager: DistributedContextManager

    private init() {
        tracerFactory = DefaultTracerFactory.instance
//        meter = DefaultMeterFactory.instance;
        distributedContextManager = DefaultDistributedContextManager.instance
    }
}
