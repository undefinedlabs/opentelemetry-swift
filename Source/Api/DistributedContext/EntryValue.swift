//
//  EntryValue.swift
//  OpenTelemetrySwift iOS
//
//  Created by Ignacio Bonafonte on 14/11/2019.
//

import Foundation

public struct EntryValue: Equatable {
    static let maxLength = 255

    private(set) var string: String = ""

    init?(string: String) {
        if !EntryValue.isValid(value: string) {
            return nil
        }
        self.string = string
    }

    private static func isValid(value: String) -> Bool {
        return value.count <= maxLength && StringUtils.isPrintableString(value)
    }
}
