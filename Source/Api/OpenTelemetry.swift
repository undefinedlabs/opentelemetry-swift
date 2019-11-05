//
//  OpenTelemetry.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 05/11/2019.
//

import Foundation

class OpenTelemetry {

    static var instance = OpenTelemetry()

    private(set) var tracer: Tracer
//    private(set) var meter: Meter
//    private(set) var contextManager: DistributedContextManager


    private init() {
        tracer = DefaultTracer.instance
//        meter = DefaultMeter.instance;
//        contextManagerProvider = DefaultDistributedContextManager.instance
    }

}
