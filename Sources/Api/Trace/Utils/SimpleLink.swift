//
//  Links.swift
//
//
//  Created by Ignacio Bonafonte on 21/10/2019.
//

import Foundation

public class SimpleLink: Link, Equatable, CustomStringConvertible {

    private static var emptyAttributes = [String: AttributeValue]()

    public var context: SpanContext
    public var attributes: [String: AttributeValue]

    public init(context: SpanContext, attributes: [String: AttributeValue] = [String: AttributeValue]()) {
        self.context = context
        self.attributes = attributes
    }
    
    public var description: String {
        return "SimpleLink{context=\(context), attributes=\(attributes)}"
    }

    public static func == (lhs: SimpleLink, rhs: SimpleLink) -> Bool {
        return lhs.context == rhs.context && lhs.attributes == rhs.attributes
    }

}
