//
//  Decision.swift
//
//
//  Created by Ignacio Bonafonte on 15/10/2019.
//

import Foundation

public struct Decision {
    /// <summary>
    /// Gets a value indicating whether Span was sampled or not.
    /// The value is not suppose to change over time and can be cached.
    /// </summary>
    private(set) var isSampled: Bool

    /// <summary>
    /// Gets a map of attributes associated with the sampling decision.
    /// </summary>
    private(set) var attributes: [String: AttributeValue]

    /// <summary>
    /// Initializes a new instance of the <see cref="Decision"/> struct.
    /// </summary>
    /// <param name="isSampled">True if sampled, false otherwise.</param>
    init(isSampled: Bool) {
        self.isSampled = isSampled
        self.attributes = [String: AttributeValue]()
    }

    /// <summary>
    /// Initializes a new instance of the <see cref="Decision"/> struct.
    /// </summary>
    /// <param name="isSampled">True if sampled, false otherwise.</param>
    /// <param name="attributes">Attributes associated with the sampling decision.</param>
    init(isSampled: Bool, attributes: [String: AttributeValue])  {
        self.isSampled = isSampled
        self.attributes = attributes
    }
}
