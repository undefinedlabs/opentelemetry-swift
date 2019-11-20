//
//  TimedEvent.swift
//  Created by Ignacio Bonafonte on 04/11/2019.
//

import Foundation
import OpenTelemetryApi

public struct TimedEvent: Equatable {
    
    public private(set) var epochNanos: Int
    public private(set) var name: String
    public private(set) var attributes: [String: AttributeValue]

    public init(nanotime: Int, name: String, attributes: [String: AttributeValue] =  [String: AttributeValue]()) {
        self.epochNanos = nanotime
        self.name = name
        self.attributes = attributes
    }

    public init(nanotime: Int, event: Event) {
        self.init(nanotime: nanotime, name: event.name, attributes: event.attributes)
    }

}
