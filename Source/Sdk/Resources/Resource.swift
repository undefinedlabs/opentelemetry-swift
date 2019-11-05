//
//  Resource.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 04/11/2019.
//

import Foundation

struct Resource {
    private static let maxLength = 255

    var labels: [String: String]

    init(labels: [String: String]) {
        if Resource.checkLabels(labels: labels) {
            self.labels = labels
        } else {
            self.labels = [String: String]()
        }
    }

    mutating func merge(other: Resource) {
        labels.merge(other.labels) { current, _ in current }
    }

    private static func checkLabels(labels: [String: String]) -> Bool {
        for entry in labels {
            if !isValidAndNotEmpty(name: entry.key) || !isValid(name: entry.value) {
                return false
            }
        }
        return true
    }

    private static func isValid(name: String) -> Bool {
        return name.count <= maxLength && StringUtils.isPrintableString(name)
    }

    private static func isValidAndNotEmpty(name: String) -> Bool {
        return !name.isEmpty && isValid(name: name)
    }
}
