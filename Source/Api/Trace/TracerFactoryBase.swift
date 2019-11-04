//
//  TracerFactoryBase.swift
//
//
//  Created by Ignacio Bonafonte on 17/10/2019.
//

import Foundation

//public class TracerFactoryBase {
//    private var proxy = ProxyTracer()
//    private var isInitialized = false
//    private static var defaultFactory: TracerFactoryBase = TracerFactoryBase()
//
//    private init() {
//        proxy = ProxyTracer()
//        isInitialized = false
//        TracerFactoryBase.defaultFactory = TracerFactoryBase()
//    }
//
//    public static func getDefault() -> TracerFactoryBase {
//        return defaultFactory
//    }
//
//    public static func setDefault(factory: TracerFactoryBase) {
//        if !defaultFactory.isInitialized {
//            defaultFactory = factory
//        }
//        defaultFactory.isInitialized = true
//    }
//
//    /// <summary>
//    /// Returns an ITracer for a given name and version.
//    /// </summary>
//    /// <param name="name">Name of the instrumentation library.</param>
//    /// <param name="version">Version of the instrumentation library (optional).</param>
//    /// <returns>Tracer for the given name and version information.</returns>
//    public func getTracer(name: String, version: String?) -> Tracer {
//        return isInitialized ? getTracer(name: name, version: version) : proxy
//    }
//
//    // for tests
//    private func reset() {
//        proxy = ProxyTracer()
//        isInitialized = false
//        TracerFactoryBase.defaultFactory = TracerFactoryBase()
//    }
//}
