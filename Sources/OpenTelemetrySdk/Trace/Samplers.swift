//
//  Samplers.swift
//
//
//  Created by Ignacio Bonafonte on 15/10/2019.
//

import Foundation
import OpenTelemetryApi

public struct Samplers {
    public static var alwaysOn: Sampler = AlwaysOnSampler()
    public static var alwaysOff: Sampler = AlwaysOffSampler()
    public static var alwaysOnDecision: Decision = SimpleDecision(decision: true)
    public static var alwaysOffDecision: Decision = SimpleDecision(decision: false)
    public static func probability(probability: Double) -> Sampler {
        return Probability(probability: probability)
    }
}



class AlwaysOnSampler: Sampler {
    func shouldSample(parentContext: SpanContext?, traceId: TraceId, spanId: SpanId, name: String, parentLinks: [Link]) -> Decision {
        return Samplers.alwaysOnDecision
    }

    var description: String {
        return String(describing: AlwaysOnSampler.self)
    }
}

class AlwaysOffSampler: Sampler {
    func shouldSample(parentContext: SpanContext?, traceId: TraceId, spanId: SpanId, name: String, parentLinks: [Link]) -> Decision {
        return Samplers.alwaysOffDecision
    }

    var description: String {
        return String(describing: AlwaysOffSampler.self)
    }
}

class Probability: Sampler {
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

    func shouldSample(parentContext: SpanContext?, traceId: TraceId, spanId: SpanId, name: String, parentLinks: [Link]) -> Decision {
        // If the parent is sampled keep the sampling decision.
        if parentContext?.traceFlags.sampled ?? false {
            return Samplers.alwaysOnDecision
        }

        for link in parentLinks {
            // If any parent link is sampled keep the sampling decision.
            if link.context.traceFlags.sampled {
                return Samplers.alwaysOnDecision
            }
        }
        // Always sample if we are within probability range. This is true even for child spans (that
        // may have had a different sampling decision made) to allow for different sampling policies,
        // and dynamic increases to sampling probabilities for debugging purposes.
        // Note use of '<' for comparison. This ensures that we never sample for probability == 0.0,
        // while allowing for a (very) small chance of *not* sampling if the id == Long.MAX_VALUE.
        // This is considered a reasonable tradeoff for the simplicity/performance requirements (this
        // code is executed in-line for every Span creation).
        if traceId.lowerLong < idUpperBound {
            return Samplers.alwaysOnDecision
        } else {
            return Samplers.alwaysOffDecision
        }
    }

    var description: String {
        return String(format: "ProbabilitySampler{%.6f}", probability)
    }
}

private struct SimpleDecision: Decision {
    let decision: Bool

    /**
     * Creates sampling decision without attributes.
     *
     * @param decision sampling decision
     */
    init(decision: Bool) {
        self.decision = decision
    }

    public var isSampled: Bool {
        return decision
    }

    /// <summary>
    /// Gets a map of attributes associated with the sampling decision.
    /// </summary>
    public var attributes: [String: AttributeValue] {
        return [String: AttributeValue]()
    }
}
