//
//  TracerFactory.swift
//
//
//  Created by Ignacio Bonafonte on 17/10/2019.
//

import Foundation

public protocol TracerFactory {
    associatedtype Tracer
    mutating func get(instrumentationName: String, instrumentationVersion: String?) -> Tracer
}
