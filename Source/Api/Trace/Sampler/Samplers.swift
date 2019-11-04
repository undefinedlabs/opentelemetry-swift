//
//  Samplers.swift
//
//
//  Created by Ignacio Bonafonte on 15/10/2019.
//

import Foundation

public struct Samplers {
    /// <summary>
    /// Gets the sampler that always sample.
    /// </summary>
    public static var AlwaysSample: Sampler { return AlwaysSampleSampler() }

    /// <summary>
    /// Gets the sampler than never samples.
    /// </summary>
    public static var NeverSample: Sampler { return NeverSampleSampler() }
}
