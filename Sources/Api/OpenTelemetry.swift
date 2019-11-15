//
//  OpenTelemetry.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 05/11/2019.
//

import Foundation

public class OpenTelemetry {
    public static var instance = OpenTelemetry()

    public private(set) var tracer: Tracer
//    private(set) var meter: Meter
    public private(set) var contextManager: DistributedContextManager

    private init() {
        tracer = DefaultTracer.instance
//        meter = DefaultMeter.instance;
        contextManager = DefaultDistributedContextManager.instance
    }
}
