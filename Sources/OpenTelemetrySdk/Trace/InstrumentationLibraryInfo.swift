//
//  File.swift
//  
//
//  Created by Ignacio Bonafonte on 18/11/2019.
//

import Foundation

public struct InstrumentationLibraryInfo: Hashable {
    var name: String = ""
    var version: String?

    public init() {
    }
    
    public init(name: String, version: String?) {
        self.name = name
        self.version = version
    }
}
