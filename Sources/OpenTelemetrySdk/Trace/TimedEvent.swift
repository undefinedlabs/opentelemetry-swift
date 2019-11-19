//
//  TimedEvent.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 04/11/2019.
//

import Foundation
import OpenTelemetryApi

struct TimedEvent: Equatable {
    private static let emptyAttributes = [String: AttributeValue]()

    private(set) var epochNanos: Int
    private(set) var name: String
    private(set) var attributes: [String: AttributeValue]

    init(nanotime: Int, name: String, attributes: [String: AttributeValue] = emptyAttributes) {
        self.epochNanos = nanotime
        self.name = name
        self.attributes = attributes
    }

    init(nanotime: Int, event: Event) {
        self.init(nanotime: nanotime, name: event.name, attributes: event.attributes)
    }

}
