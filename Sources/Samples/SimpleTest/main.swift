//
//  main.swift
//
//  Created by Ignacio Bonafonte on 19/11/2019.
//

import Foundation
import OpenTelemetryApi
import OpenTelemetrySdk

let sampleKey = "sampleKey"
let sampleValue = "sampleValue"

let instrumentationLibraryName = "SimpleTest"
let instrumentationLibraryVersion = "semver:0.1.0"
var instrumentationLibraryInfo = InstrumentationLibraryInfo(name: instrumentationLibraryName, version: instrumentationLibraryVersion)


func simpleSpan() {
    let tracer = OpenTelemetrySDK.instance.tracerFactory.get(instrumentationName: instrumentationLibraryName, instrumentationVersion: instrumentationLibraryVersion)
    let span = tracer.spanBuilder(spanName: "SimpleSpan").setSpanKind(spanKind: .client).startSpan()
    span.setAttribute(key: sampleKey, value: sampleValue)
    var scope = tracer.withSpan(span)
    DispatchQueue.global().async {
        sleep(1)
    }
    scope.close()
}

func childSpan() {
    let tracer = TracerSdkFactory().get(instrumentationName: instrumentationLibraryName, instrumentationVersion: instrumentationLibraryVersion)
    let span = tracer.spanBuilder(spanName: "parentSpan").setSpanKind(spanKind: .client).startSpan()
    span.setAttribute(key: sampleKey, value: sampleValue)
    do {
        let scope = tracer.withSpan(span)
         let childSpan = tracer.spanBuilder(spanName: "childSpan").setSpanKind(spanKind: .client).startSpan()
         do {
            let childScope = tracer.withSpan(childSpan)
            childSpan.setAttribute(key: sampleKey, value: sampleValue)
            print(childScope) // Silence unused warning
        }
        childSpan.end()
        print(scope) // Silence unused warning
    }
    span.end()
}



simpleSpan()

childSpan()
