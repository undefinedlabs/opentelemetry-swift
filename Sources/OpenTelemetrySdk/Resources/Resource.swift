//
//  Resource.swift
//  Created by Ignacio Bonafonte on 04/11/2019.
//

import Foundation
import OpenTelemetryApi

public struct Resource: Equatable {
    private static let maxLength = 255

    var labels: [String: String]

    public init(labels: [String: String]) {
        if Resource.checkLabels(labels: labels) {
            self.labels = labels
        } else {
            self.labels = [String: String]()
        }
    }

    public init() {
        self.init(labels: [String: String]())
    }

    public mutating func merge(other: Resource) {
        labels.merge(other.labels) { current, _ in current }
    }

    public func merging(other: Resource) -> Resource {
        let labelsCopy = labels.merging(other.labels) { current, _ in current }
        return Resource(labels: labelsCopy)
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
