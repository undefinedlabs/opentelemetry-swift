//
//  MillisClock.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 05/11/2019.
//

import Foundation
import OpenTelemetryApi

struct MillisClock: Clock {

    var now: Int {
        return Int(Date().timeIntervalSince1970 * 1000000000)
    }

    var nanoTime: Int {
        return Int(Date().timeIntervalSince1970 * 1000000000)
    }
}
