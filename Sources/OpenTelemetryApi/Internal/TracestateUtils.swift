//
//  TracestateUtils.swift
//
//  Created by Ignacio Bonafonte on 17/10/2019.
//

import Foundation

struct TracestateUtils {
    private static let keyMaxSize = 256
    private static let valueMaxSize = 256
    private static let maxKeyValuePairsCount = 32

    /// <summary>
    /// Extracts tracestate pairs from the given string and appends it to provided tracestate list"/>"/>.
    /// </summary>
    /// <param name="tracestateString">String with comma separated tracestate key value pairs.</param>
    /// <param name=TRACESTATE><see cref="List{T}"/> to set tracestate pairs on.</param>
    /// <returns>True if string was parsed successfully and tracestate was recognized, false otherwise.</returns>


    /// Extracts tracestate pairs from the given string and appends it to provided tracestate list
    /// - Parameters:
    ///   - tracestateString: String with comma separated tracestate key value pairs.
    ///   - tracestate: Array to set tracestate pairs on.
    static func appendTracestate(tracestateString: String, tracestate: inout [Tracestate.Entry]) -> Bool {
        guard !tracestate.isEmpty else { return false }

        var names = Set<String>()

        let tracestateString = tracestateString.trimmingCharacters(in: CharacterSet(charactersIn: " ,"))

        // tracestate: rojo=00-0af7651916cd43dd8448eb211c80319c-00f067aa0ba902b7-01,congo=BleGNlZWRzIHRohbCBwbGVhc3VyZS4
        let pair = tracestateString.components(separatedBy: ",")
        for entry in pair {
            if let entry = TracestateUtils.parseKeyValue(pairString: entry), !names.contains(entry.key) {
                names.update(with: entry.key)
                tracestate.append(entry)
            } else {
                return false
            }

            if tracestate.count == maxKeyValuePairsCount {
                break
            }
        }
        return true
    }

    /// Returns Tracestate description as a string with the values
    /// - Parameter tracestate: the tracestate to return description from
    static func getString(tracestate: Tracestate) -> String {
        let entries = tracestate.entries
        var result = ""

        if entries.isEmpty {
            return result
        }

        for entry in tracestate.entries.prefix(maxKeyValuePairsCount) {
            result += "\(entry.key)=\(entry.value),"
        }
        result.removeLast()
        return result
    }

    /// Key is opaque string up to 256 characters printable. It MUST begin with a lowercase letter, and
    /// can only contain lowercase letters a-z, digits 0-9, underscores _, dashes -, asterisks *, and
    /// forward slashes /.  For multi-tenant vendor scenarios, an at sign (@) can be used to prefix the
    /// vendor name.
    static func validateKey(key: String) -> Bool {
        let allowed = "abcdefghijklmnopqrstuvwxyz0123456789_-*/@"
        let characterSet = CharacterSet(charactersIn: allowed)

        if key.count > TracestateUtils.keyMaxSize || key.isEmpty || key.unicodeScalars.first! > "z" {
            return false
        }
        guard key.rangeOfCharacter(from: characterSet.inverted) == nil else {
            return false
        }

        if key.firstIndex(of: "@") != key.lastIndex(of: "@") {
            return false
        }

        return true
    }

    /// Value is opaque string up to 256 characters printable ASCII RFC0020 characters (i.e., the range
    /// 0x20 to 0x7E) except comma , and =.
    static func validateValue(value: String) -> Bool {
        if value.count > TracestateUtils.valueMaxSize || value.last == " " {
            return false
        }

        for scalar in value.unicodeScalars {
            if scalar.value < 0x20 || scalar.value > 0x7E || scalar == "," || scalar == "=" {
                return false
            }
        }

        return true
    }

    private static func parseKeyValue(pairString: String) -> Tracestate.Entry? {
        let pair = pairString.components(separatedBy: "=")
        guard pair.count == 2 else { return nil }

        return Tracestate.Entry(key: pair[0], value: pair[1])
    }
}
