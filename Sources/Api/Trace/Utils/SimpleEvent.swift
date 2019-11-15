//
//  Events.swift
//
//
//  Created by Ignacio Bonafonte on 21/10/2019.
//

import Foundation

public struct SimpleEvent: Event, Equatable, CustomStringConvertible {
    private static var emptyAttributes = [String: AttributeValue]()

    public private(set) var name: String
    public private(set) var attributes: [String: AttributeValue]

    public init(name: String, attributes: [String: AttributeValue] = [String: AttributeValue]()) {
        self.name = name
        self.attributes = attributes
    }

     public var description: String {
        return "SimpleEvent{name=\(name), attributes=\(attributes)}"
    }
}
