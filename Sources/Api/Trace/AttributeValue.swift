//
//  AttributeValue.swift
//
//
//  Created by Ignacio Bonafonte on 14/10/2019.
//

import Foundation

public enum AttributeValue: Equatable, CustomStringConvertible {
    case string(String)
    case bool(Bool)
    case int(Int)
    case double(Double)

    public var description: String {
        switch self {
        case let .string(value):
            return value
        case let .bool(value):
            return value ? "true" : "false"
        case let .int(value):
            return String(value)
        case let .double(value):
            return String(value)
        }
    }
}
