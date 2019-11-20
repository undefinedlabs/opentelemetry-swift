//
//  File.swift
//
//
//  Created by Ignacio Bonafonte on 19/11/2019.
//

import Foundation
import OpenTelemetryApi
import OpenTelemetrySdk

Logger.printHeader()
var tracerFactory = LoggingTracerFactory()
var tracer = tracerFactory.get(instrumentationName: "ConsoleApp", instrumentationVersion: "semver:1.0.0")


let scope = tracer.withSpan(tracer.spanBuilder(spanName: "Main (span1)").startSpan())
let semaphore = DispatchSemaphore(value: 0)
DispatchQueue.global().async {
    var scope2 = tracer.withSpan(tracer.spanBuilder(spanName: "Main (span2)").startSpan())
    tracer.currentSpan?.setAttribute(key: "myAttribute", value: "myValue")
    sleep(1)
    semaphore.signal()
    scope2.close()
}
semaphore.wait()

