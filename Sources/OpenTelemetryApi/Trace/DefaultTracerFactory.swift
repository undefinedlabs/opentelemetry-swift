//
//  File.swift
//  
//
//  Created by Ignacio Bonafonte on 18/11/2019.
//

import Foundation

public class DefaultTracerFactory: TracerFactory {

    public static let instance = DefaultTracerFactory();

    public func get(instrumentationName: String) -> Tracer {
        return get(instrumentationName: instrumentationName, instrumentationVersion: "")
    }

    public func get(instrumentationName: String, instrumentationVersion: String) -> Tracer {
        return DefaultTracer.instance
    }
}
