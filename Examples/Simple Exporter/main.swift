/*
 * Copyright 2019, Undefined Labs
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

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
