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
    public static var alwaysSample: Sampler = AlwaysSampleSampler()

    /// <summary>
    /// Gets the sampler than never samples.
    /// </summary>
    public static var neverSample: Sampler = NeverSampleSampler()
}
