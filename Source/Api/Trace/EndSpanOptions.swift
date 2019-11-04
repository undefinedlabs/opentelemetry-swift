//
//  EndSpanOptions.swift
//
//
//  Created by Ignacio Bonafonte on 14/10/2019.
//

import Foundation

public class EndSpanOptions {
    let timestamp: Timestamp?

    private init(timestamp: Timestamp?) {
        self.timestamp = timestamp
    }

    private static let DEFAULT = EndSpanOptions(timestamp: Timestamp(timeInterval: Date().timeIntervalSince1970))

    /**
     * The default {@code EndSpanOptions}.
     *
     * @since 0.1
     */
    public static func getDefault() -> EndSpanOptions {
        return DEFAULT
    }

    /**
     * Returns the end {@link Timestamp}.
     *
     * @return the end timestamp.
     * @since 0.1
     */
    public func getEndTimestamp() -> Timestamp? {
        return timestamp
    }
}
