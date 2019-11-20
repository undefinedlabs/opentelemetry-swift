//
//  TraceConfig.swift
//  Created by Ignacio Bonafonte on 04/11/2019.
//

import Foundation
import OpenTelemetryApi

public struct TraceConfig: Equatable {
    // These values are the default values for all the global parameters.
    // TODO: decide which default sampler to use
    var sampler: Sampler = Samplers.alwaysOn
    var maxNumberOfAttributes: Int = 32 {
        didSet {
            maxNumberOfAttributes < 0 ? maxNumberOfAttributes = 0 : Void()
        }
    }

    var maxNumberOfEvents: Int = 128 {
        didSet {
            maxNumberOfEvents < 0 ? maxNumberOfEvents = 0 : Void()
        }
    }

    var maxNumberOfLinks: Int = 32 {
        didSet {
            maxNumberOfLinks < 0 ? maxNumberOfLinks = 0 : Void()
        }
    }

    var maxNumberOfAttributesPerEvent: Int = 32 {
        didSet {
            maxNumberOfAttributesPerEvent < 0 ? maxNumberOfAttributesPerEvent = 0 : Void()
        }
    }

    var maxNumberOfAttributesPerLink: Int = 32 {
        didSet {
            maxNumberOfAttributesPerLink < 0 ? maxNumberOfAttributesPerLink = 0 : Void()
        }
    }

    public init() {
    }

    public func settingSampler(_ sampler: Sampler) -> Self {
        var traceConfig = self
        traceConfig.sampler = sampler
        return traceConfig
    }

    public func settingMaxNumberOfAttributes(_ number: Int) -> Self {
        var traceConfig = self
        traceConfig.maxNumberOfAttributes = number
        return traceConfig
    }

    public func settingMaxNumberOfEvents(_ number: Int) -> Self {
        var traceConfig = self
        traceConfig.maxNumberOfEvents = number
        return traceConfig
    }

    public func settingMaxNumberOfLinks(_ number: Int) -> Self {
        var traceConfig = self
        traceConfig.maxNumberOfLinks = number
        return traceConfig
    }

    public func settingMaxNumberOfAttributesPerEvent(_ number: Int) -> Self {
        var traceConfig = self
        traceConfig.maxNumberOfAttributesPerEvent = number
        return traceConfig
    }

    public func settingMaxNumberOfAttributesPerLink(_ number: Int) -> Self {
        var traceConfig = self
        traceConfig.maxNumberOfAttributesPerLink = number
        return traceConfig
    }

    public static func == (lhs: TraceConfig, rhs: TraceConfig) -> Bool {
        return lhs.sampler === rhs.sampler &&
            lhs.maxNumberOfAttributes == rhs.maxNumberOfAttributes &&
            lhs.maxNumberOfEvents == rhs.maxNumberOfEvents &&
            lhs.maxNumberOfLinks == rhs.maxNumberOfLinks &&
            lhs.maxNumberOfAttributesPerEvent == rhs.maxNumberOfAttributesPerEvent &&
            lhs.maxNumberOfAttributesPerLink == rhs.maxNumberOfAttributesPerLink
    }
}
