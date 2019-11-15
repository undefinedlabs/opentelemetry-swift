//
//  Link.swift
//
//
//  Created by Ignacio Bonafonte on 15/10/2019.
//

import Foundation

public protocol Link: AnyObject {
    /**
     * Returns the {@code SpanContext}.
     *
     * @return the {@code SpanContext}.
     * @since 0.1.0
     */
    var context: SpanContext { get }

    /**
     * Returns the set of attributes.
     *
     * @return the set of attributes.
     * @since 0.1.0
     */
    var attributes: [String: AttributeValue] { get }
}

public func == (lhs: Link, rhs: Link) -> Bool {
    return lhs.context == rhs.context && lhs.attributes == rhs.attributes
}

public func == (lhs: [Link], rhs: [Link]) -> Bool {
    return lhs.elementsEqual(rhs) { $0.context == $1.context && $0.attributes == $1.attributes }
}
