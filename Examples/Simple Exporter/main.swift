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

let instrumentationLibraryName = "SimpleExporter"
let instrumentationLibraryVersion = "semver:0.1.0"
var instrumentationLibraryInfo = InstrumentationLibraryInfo(name: instrumentationLibraryName, version: instrumentationLibraryVersion)

var tracer: Tracer!

func simpleSpan() {
    let span = tracer.spanBuilder(spanName: "SimpleSpan").setSpanKind(spanKind: .client).startSpan()
    span.setAttribute(key: sampleKey, value: sampleValue)
    span.end()
}

func childSpan() {
    let span = tracer.spanBuilder(spanName: "parentSpan").setSpanKind(spanKind: .client).startSpan()
    span.setAttribute(key: sampleKey, value: sampleValue)
    do {
        var scope = tracer.withSpan(span)
        let childSpan = tracer.spanBuilder(spanName: "childSpan").setSpanKind(spanKind: .client).startSpan()
        do {
            var childScope = tracer.withSpan(childSpan)
            childSpan.setAttribute(key: sampleKey, value: sampleValue)
            childScope.close()
        }
        childSpan.end()
        scope.close()
    }
    span.end()
}

tracer = OpenTelemetrySDK.instance.tracerFactory.get(instrumentationName: instrumentationLibraryName, instrumentationVersion: instrumentationLibraryVersion)
let spanProcessor = SimpleSpanProcessor(spanExporter: SimpleStdoutExporter())
OpenTelemetrySDK.instance.tracerFactory.addSpanProcessor(spanProcessor)

simpleSpan()
sleep(1)
childSpan()
sleep(1)

