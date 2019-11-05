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
}
