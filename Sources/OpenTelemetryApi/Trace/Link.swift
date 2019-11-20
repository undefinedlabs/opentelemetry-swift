//
//  Link.swift
//
//
//  Created by Ignacio Bonafonte on 15/10/2019.
//

import Foundation


/// A link to a Span.
/// Used (for example) in batching operations, where a single batch handler processes multiple
/// requests from different traces. Link can be also used to reference spans from the same trace.
public protocol Link: AnyObject {
    /// The SpanContext
    var context: SpanContext { get }
    /// The set of attribute
    var attributes: [String: AttributeValue] { get }
}

public func == (lhs: Link, rhs: Link) -> Bool {
    return lhs.context == rhs.context && lhs.attributes == rhs.attributes
}

public func == (lhs: [Link], rhs: [Link]) -> Bool {
    return lhs.elementsEqual(rhs) { $0.context == $1.context && $0.attributes == $1.attributes }
}
