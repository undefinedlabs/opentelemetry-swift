//
//  MillisClock.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 05/11/2019.
//

import Foundation

struct MillisClock: Clock {
    var now: Timestamp {
        return Timestamp()
    }

    var nowNanos: Int {
        return Int(Date().timeIntervalSince1970 / 1000000)
    }
}
