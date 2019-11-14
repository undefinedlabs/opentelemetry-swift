//
//  Event.swift
//
//
//  Created by Ignacio Bonafonte on 14/10/2019.
//

import Foundation

public protocol Event {
    /**
     * Return the name of the {@code Event}.
     *
     * @return the name of the {@code Event}.
     * @since 0.1.0
     */
    var name: String { get }

    /**
     * Return the attributes of the {@code Event}.
     *
     * @return the attributes of the {@code Event}.
     * @since 0.1.0
     */
    var attributes: [String: AttributeValue] { get }
}
