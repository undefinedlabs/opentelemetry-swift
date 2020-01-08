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
import OpenTelemetrySdk

public class StdoutExporter: SpanExporter {
    public init() {
    }

    public func export(spans: [SpanData]) -> SpanExporterResultCode {
        for span in spans {
            print("__________________")
            print("Span \(span.name):")
            print("TraceId: \(span.traceId.hexString)")
            print("SpanId: \(span.spanId.hexString)")
            print("Span kind: \(span.kind.rawValue)")
            print("TraceFlags: \(span.traceFlags)")
            print("Tracestate: \(span.tracestate)")
            print("ParentSpanId: \(span.parentSpanId?.hexString ?? "no Parent")")
            print("Start: \(span.startEpochNanos)")
            print("Duration: \(span.endEpochNanos - span.startEpochNanos)")
            print("------------------\n")
        }
        return .success
    }

    public func shutdown() {
    }
}