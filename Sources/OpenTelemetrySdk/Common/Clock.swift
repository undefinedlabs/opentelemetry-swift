//
//  Clock.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 04/11/2019.
//

import Foundation
import OpenTelemetryApi

public protocol Clock {
    var now: Int { get }
    var nanoTime: Int { get }
}
//
//extension Clock {
//    var nowNanos: Int {
//        return now.nanoTime
//    }
//}


public func == (lhs: Clock, rhs: Clock) -> Bool {
    return lhs.now == rhs.now && lhs.nanoTime == rhs.nanoTime
}
