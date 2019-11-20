//
//  File.swift
//  
//
//  Created by Ignacio Bonafonte on 20/11/2019.
//

import Foundation
import OpenTelemetryApi

class LoggingTracerFactory: TracerFactory {

    func get(instrumentationName: String, instrumentationVersion: String?) -> LoggingTracer {
        Logger.log("TracerFactory.get(\(instrumentationName), \(instrumentationVersion ?? ""))");
        var labels = [String: String]()
        labels["instrumentationName"] = instrumentationName
        labels["instrumentationVersion"] = instrumentationVersion
        return LoggingTracer()
    }

}
