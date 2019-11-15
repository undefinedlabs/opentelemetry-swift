//
//  ProbabilitySampler.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 05/11/2019.
//

import Foundation
import Api

class ProbabilitySampler: Sampler {
    var probability: Double
    var idUpperBound: UInt

    init(probability: Double) {
        self.probability = probability
        if probability <= 0.0 {
            idUpperBound = UInt.min
        } else if probability >= 1.0 {
            idUpperBound = UInt.max
        } else {
            idUpperBound = UInt(probability * Double(UInt.max))
        }
    }

    func shouldSample(parentContext: SpanContext?, hasRemoteParent: Bool, traceId: TraceId, spanId: SpanId, name: String, parentLinks: [Link]) -> Decision {
        // If the parent is sampled keep the sampling decision.
        if parentContext?.traceFlags.sampled ?? false {
            return Decision(isSampled: true)
        }

        for link in parentLinks {
            // If any parent link is sampled keep the sampling decision.
            if link.context.traceFlags.sampled {
                return Decision(isSampled: true)
            }
        }
        // Always sample if we are within probability range. This is true even for child spans (that
        // may have had a different sampling decision made) to allow for different sampling policies,
        // and dynamic increases to sampling probabilities for debugging purposes.
        // Note use of '<' for comparison. This ensures that we never sample for probability == 0.0,
        // while allowing for a (very) small chance of *not* sampling if the id == Long.MAX_VALUE.
        // This is considered a reasonable tradeoff for the simplicity/performance requirements (this
        // code is executed in-line for every Span creation).
        return Decision(isSampled: traceId.lowerLong < idUpperBound)
    }

    var description: String {
        return String(format: "ProbabilitySampler{%.6f}", probability)
    }
}
