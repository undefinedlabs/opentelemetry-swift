//
//  EntryKey.swift
//  OpenTelemetrySwift iOS
//
//  Created by Ignacio Bonafonte on 14/11/2019.
//

import Foundation

public struct EntryKey: Equatable, Hashable {
    static let maxLength = 255
    private(set) var name: String = ""

    init?(name: String) {
        if !EntryKey.isValid(value: name) {
            return nil
        }
        self.name = name
    }

    private static func isValid(value: String) -> Bool {
        return value.count > 0 && value.count <= maxLength && StringUtils.isPrintableString(value)
    }
}
