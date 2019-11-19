//
//  EndSpanOptions.swift
//
//
//  Created by Ignacio Bonafonte on 14/10/2019.
//

import Foundation

public struct EndSpanOptions {
    var timestamp: Int = 0

    /**
     * Returns the end {@link Timestamp}.
     *
     * @return the end timestamp.
     * @since 0.1
     */
    public func getEndTimestamp() -> Int {
        return timestamp
    }
}
