//
//  File 2.swift
//
//
//  Created by Ignacio Bonafonte on 14/10/2019.
//

import Foundation

public struct Timestamp: Equatable, Comparable {
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
    public init() {
        self.timeInterval = Date().timeIntervalSince1970
    }


    public init(timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
    }

    public init(fromMillis: Int) {
        timeInterval = Double(fromMillis) / 1000
    }

    public init(fromSeconds: Int, nanoseconds: Int) {
        timeInterval = Double(fromSeconds) + ( Double(nanoseconds) / 1000_000_000 )
    }

    public func getSeconds() -> Int {
        return Int(floor(timeInterval))
    }

    public func getNanos() -> Int {
        return Int(floor(timeInterval * 1000_000_000))
    }

    public static func < (lhs: Timestamp, rhs: Timestamp) -> Bool {
        return lhs.timeInterval < rhs.timeInterval
    }
}
