//
//  AttributeValue.swift
//
//
//  Created by Ignacio Bonafonte on 14/10/2019.
//

import Foundation

public enum AttributeValue:Equatable, CustomStringConvertible {

    case string(String)
    case bool(Bool)
    case int(Int)
    case double(Double)

    public var description: String {
        switch self {
        case .string(let value):
            return value
        case .bool(let value):
            return value ? "true" : "false"
        case .int(let value):
            return String(value)
        case .double(let value):
            return String(value)
        }
    }

}
