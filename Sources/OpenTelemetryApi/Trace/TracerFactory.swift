//
//  TracerFactory.swift
//
//  Created by Ignacio Bonafonte on 17/10/2019.
//

import Foundation

/// A factory for creating named Tracers.
public protocol TracerFactory {
    associatedtype Tracer

    /// Gets or creates a named tracer instance.
    /// - Parameters:
    ///   - instrumentationName: the name of the instrumentation library, not the name of the instrumented library
    ///   - instrumentationVersion:  The version of the instrumentation library (e.g., "semver:1.0.0"). Optional
    mutating func get(instrumentationName: String, instrumentationVersion: String?) -> Tracer
}
