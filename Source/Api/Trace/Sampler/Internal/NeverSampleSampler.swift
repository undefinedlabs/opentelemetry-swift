//
//  NeverSampleSampler.swift
//  
//
//  Created by Ignacio Bonafonte on 15/10/2019.
//

import Foundation

struct NeverSampleSampler: Sampler {

    func shouldSample(parentContext: SpanContext, traceId: TraceId, spanId: SpanId, name: String, parentLinks: [Link]) -> Decision {
        return Decision(isSampled:false)
    }

    var description: String {
        return String(describing: self)
    }

}
