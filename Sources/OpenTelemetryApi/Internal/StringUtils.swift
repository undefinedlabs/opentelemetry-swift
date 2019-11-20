//
//  StringUtils.swift
//  Created by Ignacio Bonafonte on 04/11/2019.
//

import Foundation

/// Internal utility methods for working with attribute keys, attribute values, and metric names
public struct StringUtils {
    /// Determines whether the String contains only printable characters.
    /// - Parameter string: the String to be validated.
    public static func isPrintableString(_ string: String) -> Bool {
        for char in string.unicodeScalars {
            if !isPrintableChar(char) {
                return false
            }
        }
        return true
    }

    private static func isPrintableChar(_ char: Unicode.Scalar) -> Bool {
        return char >= UnicodeScalar(" ") && char <= UnicodeScalar("~")
    }
}
