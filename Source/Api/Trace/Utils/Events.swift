//
//  Events.swift
//
//
//  Created by Ignacio Bonafonte on 21/10/2019.
//

import Foundation

struct Events {
    private static var emptyAttributes = [String: AttributeValue]()

    public static func create(name: String) -> SimpleEvent {
        return SimpleEvent(name: name, attributes: emptyAttributes)
    }

    public static func create(name: String, attributes: [String: AttributeValue]) -> SimpleEvent {
        return SimpleEvent(name: name, attributes: attributes)
    }

    struct SimpleEvent: Event {
        var name: String
        var attributes: [String: AttributeValue]
    }
}
