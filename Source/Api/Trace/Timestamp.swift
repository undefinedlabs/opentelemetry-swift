//
//  File 2.swift
//
//
//  Created by Ignacio Bonafonte on 14/10/2019.
//

import Foundation

public struct Timestamp: Comparable {
    var timeInterval: TimeInterval

    /**
     * Creates a new timestamp from the given milliseconds.
     *
     * @param epochMilli the timestamp represented in milliseconds since epoch.
     * @return new {@code Timestamp} with specified fields.
     * @throws IllegalArgumentException if the number of milliseconds is out of the range that can be
     *     represented by {@code Timestamp}.
     * @since 0.1.0
     */
    init() {
        self.timeInterval = Date().timeIntervalSince1970
    }


    init(timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
    }

    init(fromMillis: Int) {
        timeInterval = Double(fromMillis) / 1000
    }

    public func getSeconds() -> Int {
        return Int(floor(timeInterval))
    }

    public func getNanos() -> Int {
        return Int(floor(timeInterval.truncatingRemainder(dividingBy: 1) * 1000000))
    }

    public static func < (lhs: Timestamp, rhs: Timestamp) -> Bool {
        return lhs.timeInterval < rhs.timeInterval
    }
}
