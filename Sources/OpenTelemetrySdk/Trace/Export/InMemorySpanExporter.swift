//
//  InMemorySpanExporter.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 05/11/2019.
//

import Foundation

/**
 * A {@link SpanExporter} implementation that can be used to test OpenTelemetry integration.
 *
 * <p>Example usage:
 *
 * <pre><code>
 * class MyClassTest {
 *   private final Tracer tracer = new TracerSdk();
 *   private final InMemorySpanExporter testExporter = InMemorySpanExporter.create();
 *
 *   {@literal @}Before
 *   public void setup() {
 *     tracer.addSpanProcessor(SimpleSampledSpansProcessor.newBuilder(testExporter).build());
 *   }
 *
 *   {@literal @}Test
 *   public void getFinishedSpanData() {
 *     tracer.spanBuilder("span").startSpan().end();
 *
 *     {@code List<Span> spanItems} = exporter.getFinishedSpanItems();
 *     assertThat(spanItems).isNotNull();
 *     assertThat(spanItems.size()).isEqualTo(1);
 *     assertThat(spanItems.get(0).getName()).isEqualTo("span");
 *   }
 * </code></pre>
 */
class InMemorySpanExporter: SpanExporter {
    private(set) var finishedSpanItems = [SpanData]()
    private var isStopped = false

    func export(spans: [SpanData]) -> SpanExporterResultCode {
        if isStopped {
            return .failedNotRetryable
        }
        finishedSpanItems.append(contentsOf: spans)
        return .success
    }

    func shutdown() {
        finishedSpanItems.removeAll()
        isStopped = true
    }

    func reset() {
        finishedSpanItems.removeAll()
    }
}
