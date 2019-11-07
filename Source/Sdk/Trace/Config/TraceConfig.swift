//
//  TraceConfig.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 04/11/2019.
//

import Foundation

struct TraceConfig {
    // These values are the default values for all the global parameters.
    // TODO: decide which default sampler to use
    var sampler: Sampler = Samplers.alwaysSample
    var maxNumberOfAttributes: Int = 32
    var maxNumberOfEvents: Int = 128
    var maxNumberOfLinks: Int = 32
    var maxNumberOfAttributesPerEvent: Int = 32
    var maxNumberOfAttributesPerLink: Int = 32

    func settingSampler(sampler: Sampler) -> Self {
        var traceConfig = self
        traceConfig.sampler = sampler
        return traceConfig
    }

    func settingMaxNumberOfAttributes(_ number: Int) -> Self {
        var traceConfig = self
        traceConfig.maxNumberOfAttributes = number
        return self
    }

    func settingMaxNumberOfEvents(_ number: Int) -> Self {
        var traceConfig = self
        traceConfig.maxNumberOfEvents = number
        return self
    }

    func settingMaxNumberOfLinks(_ number: Int) -> Self {
        var traceConfig = self
        traceConfig.maxNumberOfLinks = number
        return self
    }

    func settingMaxNumberOfAttributesPerEvent(_ number: Int) -> Self {
        var traceConfig = self
        traceConfig.maxNumberOfAttributesPerEvent = number
        return self
    }

    func settingMaxNumberOfAttributesPerLink(_ number: Int) -> Self {
        var traceConfig = self
        traceConfig.maxNumberOfAttributesPerLink = number
        return self
    }
}
