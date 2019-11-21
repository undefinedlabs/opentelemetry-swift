//
//  TimedEvent.swift
//  Created by Ignacio Bonafonte on 04/11/2019.
//

import Foundation
import OpenTelemetryApi

/// Timed event.
public struct TimedEvent: Equatable {
    public private(set) var epochNanos: Int
    public private(set) var name: String
    public private(set) var attributes: [String: AttributeValue]

    /// Creates an TimedEvent with the given time, name and empty attributes.
    /// - Parameters:
    ///   - nanotime: epoch timestamp in nanos.
    ///   - name: the name of this TimedEvent.
    ///   - attributes: the attributes of this TimedEvent. Empty by default.
    public init(nanotime: Int, name: String, attributes: [String: AttributeValue] = [String: AttributeValue]()) {
        epochNanos = nanotime
        self.name = name
        self.attributes = attributes
    }

    /// Creates an TimedEvent with the given time and event.
    /// - Parameters:
    ///   - nanotime: epoch timestamp in nanos.
    ///   - event: the event.
    public init(nanotime: Int, event: Event) {
        self.init(nanotime: nanotime, name: event.name, attributes: event.attributes)
    }
}
