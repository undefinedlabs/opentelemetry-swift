//
//  Links.swift
//
//
//  Created by Ignacio Bonafonte on 21/10/2019.
//

import Foundation

struct SimpleLink: Link, Equatable, CustomStringConvertible {

    private static var emptyAttributes = [String: AttributeValue]()

    var context: SpanContext
    var attributes: [String: AttributeValue]

    init(context: SpanContext, attributes: [String: AttributeValue] = emptyAttributes) {
        self.context = context
        self.attributes = attributes
    }
    
     public var description: String {
        return "SimpleLink{context=\(context), attributes=\(attributes)}"
    }

    func isEqualTo(_ other: Link) -> Bool {
        return context == other.context && attributes == other.attributes
    }

}
