//
//  Clock.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 04/11/2019.
//

import Foundation

protocol Clock {
    var now: Timestamp { get }
    var nowNanos: Int { get }
}

extension Clock {
    var nowNanos: Int {
        return Int(now.timeInterval * Double(TimestampConverter.nanosPerSecond))
    }
}
