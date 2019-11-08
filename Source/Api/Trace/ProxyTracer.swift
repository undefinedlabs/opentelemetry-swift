//
//  ProxyTracer.swift
//  
//
//  Created by Ignacio Bonafonte on 16/10/2019.
//

//import Foundation
//
//struct ProxyTracer: Tracer {
//
//    private var scope = NoopScope()
//    var BinaryTraceContextFormat = BinaryTraceContextFormat()
//    var textFormat: TextFormattable = TraceContextFormat()
//
//    private var realTracer: Tracer?;
//
//    var currentSpan: Span? {
//        return realTracer?.currentSpan ?? DefaultSpan()
//    }
//
//    func withSpan(span: Span) -> Scope {
//        return realTracer?.withSpan(span: span) ?? NoopScope()
//    }
//
//    func startRootSpan(operationName: String, kind: SpanKind, startTimestamp: Timestamp, links: [Link]?) -> Span {
//        return realTracer?.startRootSpan(operationName: operationName, kind: kind, startTimestamp: startTimestamp, links: links) ?? DefaultSpan()
//    }
//
//    func startSpan(operationName: String, kind: SpanKind, startTimestamp: Timestamp, links: [Link]?) -> Span {
//        return realTracer?.startSpan(operationName: operationName, kind: kind, startTimestamp: startTimestamp, links: links) ?? DefaultSpan()
//    }
//
//    func startSpan(operationName: String, parent: Span, kind: SpanKind, startTimestamp: Timestamp, links: [Link]?) -> Span {
//        return realTracer?.startSpan(operationName: operationName, parent:parent, kind: kind, startTimestamp: startTimestamp, links: links) ?? DefaultSpan()
//
//    }
//
//    func startSpan(operationName: String, parent: SpanContext, kind: SpanKind, startTimestamp: Timestamp, links: [Link]?) -> Span {
//        return realTracer?.startSpan(operationName: operationName, parent:parent, kind: kind, startTimestamp: startTimestamp, links: links) ?? DefaultSpan()
//    }
//
//    public mutating func update( tracer: Tracer ) {
//        if realTracer == nil {
//            realTracer = tracer
//        }
//    }
//}
