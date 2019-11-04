//
//  Events.swift
//
//
//  Created by Ignacio Bonafonte on 21/10/2019.
//

import Foundation

struct SimpleEvent: Event, Equatable, CustomStringConvertible {
    private static var emptyAttributes = [String: AttributeValue]()

    var name: String
    var attributes: [String: AttributeValue]

    init(name: String, attributes: [String: AttributeValue] = emptyAttributes) {
        self.name = name
        self.attributes = attributes
    }

     public var description: String {
        return "SimpleEvent{name=\(name), attributes=\(attributes)}"
    }
}
