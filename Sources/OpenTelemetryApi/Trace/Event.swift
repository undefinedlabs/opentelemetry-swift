//
//  Event.swift
//
//
//  Created by Ignacio Bonafonte on 14/10/2019.
//

import Foundation

/// A text annotation with a set of attributes.
public protocol Event {

    /// The name of the Event.
    var name: String { get }

    /// The attributes of the Event.
    var attributes: [String: AttributeValue] { get }
}
