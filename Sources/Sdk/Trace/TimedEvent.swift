//
//  TimedEvent.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 04/11/2019.
//

import Foundation
import Api

struct TimedEvent: Equatable {
    private static let emptyAttributes = [String: AttributeValue]()

    private(set) var nanoTime: Int
    private(set) var name: String
    private(set) var attributes: [String: AttributeValue]

    init(nanotime: Int, name: String, attributes: [String: AttributeValue] = emptyAttributes) {
        nanoTime = nanotime
        self.name = name
        self.attributes = attributes
    }

    init(nanotime: Int, event: Event) {
        nanoTime = nanotime
        name = event.name
        attributes = event.attributes
    }

    init(timestamp: Timestamp, event: Event) {
        let nanoTime = timestamp.seconds * TimestampConverter.nanosPerSecond + timestamp.nanos
        self.init(nanotime: nanoTime, event: event)
    }
}
