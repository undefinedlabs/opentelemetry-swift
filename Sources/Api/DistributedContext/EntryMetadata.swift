//
//  EntryMetadata.swift
//  OpenTelemetrySwift iOS
//
//  Created by Ignacio Bonafonte on 14/11/2019.
//

import Foundation

public enum EntryTtl {
    case noPropagation
    case unlimitedPropagation
}

public struct EntryMetadata: Equatable {
    var entryTtl: EntryTtl

    public init( entryTtl: EntryTtl) {
        self.entryTtl = entryTtl
    }
}
