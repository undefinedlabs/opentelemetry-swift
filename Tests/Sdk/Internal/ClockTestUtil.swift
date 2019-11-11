//
import Foundation
//  ClockTestUtil.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 06/11/2019.
//
import OpenTelemetrySwift

struct ClockTestUtil {
    static let nanosPerSecond = 1000 * 1000 * 1000
    static let nanosPerMilli = 1000 * 1000

    static func createTimestamp(seconds: Int, nanos: Int) -> Timestamp {
        return Timestamp(seconds: seconds, nanos: nanos)
    }
}
