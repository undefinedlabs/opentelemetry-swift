//
//  File.swift
//  
//
//  Created by Ignacio Bonafonte on 18/11/2019.
//

import Foundation

public class DefaultTracerFactory: TracerFactory {

    public static let instance = DefaultTracerFactory();

    public func get(instrumentationName: String, instrumentationVersion: String?) -> DefaultTracer {
        return DefaultTracer.instance
    }
}
