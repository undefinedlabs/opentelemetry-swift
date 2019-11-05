//
//  TimedEvent.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 04/11/2019.
//

import Foundation

struct TimedEvent {

    private static let emptyAttributes = [String: AttributeValue]()

    private(set) var nanotime: Int
    private(set) var name: String
    private(set) var attributes:[String: AttributeValue]

    init( nanotime: Int, name: String, attributes: [String: AttributeValue] = emptyAttributes) {
        self.nanotime = nanotime
        self.name = name
        self.attributes = attributes
    }

    init(nanotime: Int, event: Event) {
        self.nanotime = nanotime
        self.name = event.name
        self.attributes = event.attributes
    }
}
