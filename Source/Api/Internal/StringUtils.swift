//
//  StringUtils.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 04/11/2019.
//

import Foundation

struct StringUtils {
    static func isPrintableString(_ string: String) -> Bool {
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
