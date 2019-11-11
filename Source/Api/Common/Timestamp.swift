//
//  File 2.swift
//
//
//  Created by Ignacio Bonafonte on 14/10/2019.
//

import Foundation

public struct Timestamp: Equatable, Comparable {
    static let maxSeconds = 315576000000
    static let maxNanos = 999999999
    static let millisPerSecond = 1000.0
    static let nanosPerMilli = 1000000.0
    public var seconds: Int = 0
    public var nanos: Int = 0

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
    }

    public init(seconds: Int, nanos: Int) {
        self.seconds = min(max(seconds, -Timestamp.maxSeconds), Timestamp.maxSeconds)
        self.nanos = min(max(nanos, 0), Timestamp.maxNanos)
    }

    public init(fromMillis: Int) {
        let millis = Double(fromMillis)
        let seconds = floor(millis / Timestamp.millisPerSecond)
        let nanos = floor(abs(millis - (seconds * Timestamp.millisPerSecond)))

        self.init(seconds: Int(seconds), nanos: Int(nanos * Timestamp.nanosPerMilli))
    }

    public static func < (lhs: Timestamp, rhs: Timestamp) -> Bool {
        return lhs.seconds < rhs.seconds || ( lhs.seconds == rhs.seconds && lhs.nanos < rhs.nanos)
    }
}
