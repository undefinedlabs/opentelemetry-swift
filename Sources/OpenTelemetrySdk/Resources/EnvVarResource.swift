//
//  EnvVarResource.swift
//
//  Created by Ignacio Bonafonte on 05/11/2019.
//

import Foundation

public struct EnvVarResource {
    private static let ocResourceLabelsEnv = "OC_RESOURCE_LABELS"
    private static let labelListSplitter = Character(",")
    private static let labelKeyValueSplitter = Character("=")

    public static let resource = Resource(labels: parseResourceLabels(rawEnvLabels: ProcessInfo.processInfo.environment["ocResourceLabelsEnv"]))

    private init() {}

    /*
     * Creates a label map from the OC_RESOURCE_LABELS environment variable.
     *
     * OC_RESOURCE_LABELS: A comma-separated list of labels describing the source in more detail,
     * e.g. “key1=val1,key2=val2”. Domain names and paths are accepted as label keys. Values may be
     * quoted or unquoted in general. If a value contains whitespaces, =, or " characters, it must
     * always be quoted.
     */
    private static func parseResourceLabels(rawEnvLabels: String?) -> [String: String] {
        guard let rawEnvLabels = rawEnvLabels else { return [String: String]() }

        var labels = [String: String]()

        rawEnvLabels.split(separator: labelListSplitter).forEach {
            let split = $0.split(separator: labelKeyValueSplitter)
            if split.count != 2 {
                return
            }
            let key = split[0].trimmingCharacters(in: .whitespaces)
            let value = split[1].trimmingCharacters(in: CharacterSet(charactersIn: "^\"|\"$"))
            labels[key] = value
        }
        return labels
    }
}
