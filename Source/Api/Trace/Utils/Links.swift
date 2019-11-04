//
//  Links.swift
//  
//
//  Created by Ignacio Bonafonte on 21/10/2019.
//

import Foundation

struct Links {
    private static var emptyAttributes = [String: AttributeValue]()

    public static func create( context: SpanContext, attributes: [String: AttributeValue])-> Link {
       return SimpleLink(context: context, attributes: attributes)
   }

    struct SimpleLink: Link {
        var context: SpanContext
        var attributes: [String : AttributeValue]
   }
}
