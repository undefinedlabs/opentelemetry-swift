//
//  MillisClock.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 05/11/2019.
//

import Foundation
import OpenTelemetryApi

public class MillisClock: Clock {

    public var now: Int {
        return Int(Date().timeIntervalSince1970 * 1000000000)
    }

    public var nanoTime: Int {
        return Int(Date().timeIntervalSince1970 * 1000000000)
    }
}
