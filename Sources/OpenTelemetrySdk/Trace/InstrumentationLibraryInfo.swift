//
//  InstrumentationLibraryInfo.swift
//  //
//  Created by Ignacio Bonafonte on 18/11/2019.
//

import Foundation

/// Holds information about the instrumentation library specified when creating an instance of
/// TracerSdk using TracerSdkFactory.
public struct InstrumentationLibraryInfo: Hashable {
    public private(set) var name: String = ""
    public private(set) var version: String?

    ///  Creates a new empty instance of InstrumentationLibraryInfo.
    public init() {
    }

    ///  Creates a new instance of InstrumentationLibraryInfo.
    ///  - Parameters:
    ///    - name: name of the instrumentation library
    ///    - version: version of the instrumentation library (e.g., "semver:1.0.0"), might be nil
    public init(name: String, version: String?) {
        self.name = name
        self.version = version
    }
}
