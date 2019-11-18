//
//  NeverSampleSampler.swift
//  
//
//  Created by Ignacio Bonafonte on 15/10/2019.
//

import Foundation

class NeverSampleSampler: Sampler {

    func shouldSample(parentContext: SpanContext?, hasRemoteParent: Bool, traceId: TraceId, spanId: SpanId, name: String, parentLinks: [Link]) -> Decision {
        return Decision(isSampled:false)
    }

    var description: String {
        return String(describing: NeverSampleSampler.self)
    }

}
