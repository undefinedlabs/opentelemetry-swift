//
//  SpanBuilderSDK.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 04/11/2019.
//

import Foundation

class SpanBuilderSdk: SpanBuilder {
    private enum ParentType {
        case currentSpan
        case explicitParent
        case explicitRemoteParent
        case noParent
    }

    static let invalidId = 0
    static let traceOptionsSampled = TraceFlags().settingIsSampled(true)
    static let traceOptionsNotSampled = TraceFlags().settingIsSampled(false)

    private var spanName: String
    private var spanProcessor: SpanProcessor
    private var traceConfig: TraceConfig
    private var resource: Resource
    private var clock: Clock

    private var parent: Span?
    private var remoteParent: SpanContext?
    private var spanKind = SpanKind.internal

    private var links = [Link]()
    private var sampler: Sampler
    private var parentType: ParentType = .currentSpan

    private var startTimestamp: Timestamp?

    init(spanName: String, spanProcessor: SpanProcessor, traceConfig: TraceConfig, resource: Resource, clock: Clock) {
        self.spanName = spanName
        self.spanProcessor = spanProcessor
        self.traceConfig = traceConfig
        self.resource = resource
        self.clock = clock
        sampler = traceConfig.sampler
    }

    func setParent(_ parent: Span) -> SpanBuilder {
        self.parent = parent
        remoteParent = nil
        parentType = .explicitParent
        return self
    }

    func setParent(_ parent: SpanContext) -> SpanBuilder {
        remoteParent = parent
        self.parent = nil
        parentType = .explicitRemoteParent
        return self
    }

    func setNoParent() -> SpanBuilder {
        parentType = .noParent
        remoteParent = nil
        parent = nil
        return self
    }

    func setSampler(sampler: Sampler) -> SpanBuilder {
        self.sampler = sampler
        return self
    }

    func addLink(spanContext: SpanContext) -> SpanBuilder {
        return addLink(SimpleLink(context: spanContext))
    }

    func addLink(spanContext: SpanContext, attributes: [String: AttributeValue]) -> SpanBuilder {
        return addLink(SimpleLink(context: spanContext, attributes: attributes))
    }

    func addLink(_ link: Link) -> SpanBuilder {
        links.append(link)
        return self
    }

    func setSpanKind(spanKind: SpanKind) -> SpanBuilder {
        self.spanKind = spanKind
        return self
    }

    func setStartTimestamp(startTimestamp: Timestamp) -> SpanBuilder {
        self.startTimestamp = startTimestamp
        return self
    }

    func startSpan() -> Span {
        var parentContext = getParentContext(parentType: parentType, explicitParent: parent, remoteParent: remoteParent)
        let traceId: TraceId
        let spanId = SpanId.random()
        var tracestate = Tracestate()

        if parentContext?.isValid ?? false {
            traceId = parentContext!.traceId
            tracestate = parentContext!.tracestate
        } else {
            traceId = TraceId.random()
            parentContext = nil
        }

        let samplingDecision = sampler.shouldSample(parentContext: parentContext, hasRemoteParent: false, traceId: traceId, spanId: spanId, name: spanName, parentLinks: links)
        let timestampConverter = SpanBuilderSdk.getTimestampConverter(parent: SpanBuilderSdk.getParentSpan(parentType: parentType, explicitParent: parent))

        let spanContext = SpanContext(traceId: traceId, spanId: spanId, traceFlags: TraceFlags().settingIsSampled(samplingDecision.isSampled), tracestate: tracestate)
        return RecordEventsReadableSpan.startSpan(context: spanContext, name: spanName, kind: spanKind, parentSpanId: parentContext?.spanId, traceConfig: traceConfig, spanProcessor: spanProcessor, timestampConverter: timestampConverter, clock: clock, resource: resource, attributes: samplingDecision.attributes, links: truncatedLinks, totalRecordedLinks: links.count)
    }

    private var truncatedLinks: [Link] {
        return links.suffix(Int(traceConfig.maxNumberOfLinks))
    }

    private func getParentContext(parentType: ParentType, explicitParent: Span?, remoteParent: SpanContext?) -> SpanContext? {
        let currentSpan = ContextUtils.getCurrent()
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
            return ContextUtils.getCurrent()
        case .explicitParent:
            return explicitParent
        default:
            return nil
        }
    }

    private static func getTimestampConverter(parent: Span?) -> TimestampConverter? {
        var timestampConverter: TimestampConverter?
        if let parentRecordEventSpan = parent as? RecordEventsReadableSpan {
            timestampConverter = parentRecordEventSpan.timestampConverter
            parentRecordEventSpan.addChild()
        }
        return timestampConverter
    }
}
