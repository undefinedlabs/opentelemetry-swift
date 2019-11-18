//
//  Sampler.swift
//
//
//  Created by Ignacio Bonafonte on 15/10/2019.
//

import Foundation

public protocol Sampler: AnyObject, CustomStringConvertible {
    /// <summary>
    /// Checks whether span needs to be created and tracked.
    /// </summary>
    /// <param name="parentContext">Parent span context. Typically taken from the wire.</param>
    /// <param name="traceId">Trace ID of a span to be created.</param>
    /// <param name="spanId">Span ID of a span to be created.</param>
    /// <param name="name"> Name of a span to be created. Note, that the name of the span is settable.
    /// So this name can be changed later and <see cref="ISampler"/> implementation should assume that.
    /// Typical example of a name change is when <see cref="ISpan"/> representing incoming http request
    /// has a name of url path and then being updated with route name when routing complete.
    /// </param>
    /// <param name="links">Links associated with the span.</param>
    /// <returns>Sampling decision on whether Span needs to be sampled or not.</returns>
    func shouldSample(parentContext: SpanContext?, hasRemoteParent: Bool, traceId: TraceId, spanId: SpanId, name: String, parentLinks: [Link]) -> Decision
}

public struct Decision {
    /// <summary>
    /// Gets a value indicating whether Span was sampled or not.
    /// The value is not suppose to change over time and can be cached.
    /// </summary>
    public private(set) var isSampled: Bool

    /// <summary>
    /// Gets a map of attributes associated with the sampling decision.
    /// </summary>
    public  private(set) var attributes: [String: AttributeValue]

    /// <summary>
    /// Initializes a new instance of the <see cref="Decision"/> struct.
    /// </summary>
    /// <param name="isSampled">True if sampled, false otherwise.</param>
    public init(isSampled: Bool) {
        self.isSampled = isSampled
        attributes = [String: AttributeValue]()
    }

    /// <summary>
    /// Initializes a new instance of the <see cref="Decision"/> struct.
    /// </summary>
    /// <param name="isSampled">True if sampled, false otherwise.</param>
    /// <param name="attributes">Attributes associated with the sampling decision.</param>
    public init(isSampled: Bool, attributes: [String: AttributeValue]) {
        self.isSampled = isSampled
        self.attributes = attributes
    }
}
