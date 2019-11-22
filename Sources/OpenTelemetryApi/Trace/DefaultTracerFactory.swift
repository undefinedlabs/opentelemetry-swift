//
//  DefaultTracerFactory.swift
//
//  Created by Ignacio Bonafonte on 18/11/2019.
//

import Foundation

public class DefaultTracerFactory: TracerFactory {
    public static let instance = DefaultTracerFactory()

    public override func get(instrumentationName: String, instrumentationVersion: String?) -> Tracer {
        return DefaultTracer.instance
    }
}
