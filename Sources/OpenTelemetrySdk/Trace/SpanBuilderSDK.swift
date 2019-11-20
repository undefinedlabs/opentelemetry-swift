//
//  SpanBuilderSDK.swift
//  Created by Ignacio Bonafonte on 04/11/2019.
//

import Foundation
import OpenTelemetryApi

public class SpanBuilderSdk: SpanBuilder {
    private enum ParentType {
        case currentSpan
        case explicitParent
        case explicitRemoteParent
        case noParent
    }

    static let traceOptionsSampled = TraceFlags().settingIsSampled(true)
    static let traceOptionsNotSampled = TraceFlags().settingIsSampled(false)

    private var spanName: String
    private var instrumentationLibraryInfo: InstrumentationLibraryInfo
    private var spanProcessor: SpanProcessor
    private var traceConfig: TraceConfig
    private var resource: Resource
    private var idsGenerator: IdsGenerator
    private var clock: Clock

    private var parent: Span?
    private var remoteParent: SpanContext?
    private var spanKind = SpanKind.internal

    private var links = [Link]()
    private var parentType: ParentType = .currentSpan

    private var startEpochNanos: Int = 0

    public init(spanName: String, instrumentationLibraryInfo: InstrumentationLibraryInfo, spanProcessor: SpanProcessor, traceConfig: TraceConfig, resource: Resource, idsGenerator: IdsGenerator, clock: Clock) {
        self.spanName = spanName
        self.instrumentationLibraryInfo = instrumentationLibraryInfo
        self.spanProcessor = spanProcessor
        self.traceConfig = traceConfig
        self.resource = resource
        self.idsGenerator = idsGenerator
        self.clock = clock
    }

    public func setParent(_ parent: Span) -> Self {
        self.parent = parent
        remoteParent = nil
        parentType = .explicitParent
        return self
    }

    public func setParent(_ parent: SpanContext) -> Self {
        remoteParent = parent
        self.parent = nil
        parentType = .explicitRemoteParent
        return self
    }

    public func setNoParent() -> Self {
        parentType = .noParent
        remoteParent = nil
        parent = nil
        return self
    }

    public func addLink(spanContext: SpanContext) -> Self {
        return addLink(SpanData.Link(context: spanContext))
    }

    public func addLink(spanContext: SpanContext, attributes: [String: AttributeValue]) -> Self {
        return addLink(SpanData.Link(context: spanContext, attributes: attributes))
    }

    public func addLink(_ link: Link) -> Self {
        links.append(link)
        return self
    }

    public func setSpanKind(spanKind: SpanKind) -> Self {
        self.spanKind = spanKind
        return self
    }

    public func setStartTimestamp(startTimestamp: Int) -> Self {
        startEpochNanos = startTimestamp
        return self
    }

    public func startSpan() -> Span {
        var parentContext = getParentContext(parentType: parentType, explicitParent: parent, remoteParent: remoteParent)
        let traceId: TraceId
        let spanId = idsGenerator.generateSpanId()
        var tracestate = Tracestate()

        if parentContext?.isValid ?? false {
            traceId = parentContext!.traceId
            tracestate = parentContext!.tracestate
        } else {
            traceId = idsGenerator.generateTraceId()
            parentContext = nil
        }

        let samplingDecision = traceConfig.sampler.shouldSample(parentContext: parentContext, traceId: traceId, spanId: spanId, name: spanName, parentLinks: links)

        let spanContext = SpanContext.create(traceId: traceId, spanId: spanId, traceFlags: TraceFlags().settingIsSampled(samplingDecision.isSampled), tracestate: tracestate)

        if !samplingDecision.isSampled {
            return DefaultSpan(context: spanContext, kind: spanKind)
        }

        return RecordEventsReadableSpan.startSpan(context: spanContext, name: spanName, instrumentationLibraryInfo: instrumentationLibraryInfo, kind: spanKind, parentSpanId: parentContext?.spanId, hasRemoteParent: parentContext?.isRemote ?? false,  traceConfig: traceConfig, spanProcessor: spanProcessor, clock: SpanBuilderSdk.getClock(parent: parent, clock: clock), resource: resource, attributes: samplingDecision.attributes, links: truncatedLinks, totalRecordedLinks: links.count, startEpochNanos: startEpochNanos)
    }

    private var truncatedLinks: [Link] {
        return links.suffix(Int(traceConfig.maxNumberOfLinks))
    }

    private static func getClock(parent: Span?, clock: Clock) -> Clock {
        if let parentRecordEventSpan = parent as? RecordEventsReadableSpan {
            parentRecordEventSpan.addChild()
            return parentRecordEventSpan.clock
        } else {
            return MonotonicClock(clock: clock);
        }
    }

    private func getParentContext(parentType: ParentType, explicitParent: Span?, remoteParent: SpanContext?) -> SpanContext? {
        let currentSpan = ContextUtils.getCurrentSpan()
        switch parentType {
        case .noParent:
            return nil
        case .currentSpan:
            return currentSpan?.context
        case .explicitParent:
            return explicitParent?.context
        case .explicitRemoteParent:
            return remoteParent
        }
    }

    private static func getParentSpan(parentType: ParentType, explicitParent: Span?) -> Span? {
        switch parentType {
        case .currentSpan:
            return ContextUtils.getCurrentSpan()
        case .explicitParent:
            return explicitParent
        default:
            return nil
        }
    }
}
