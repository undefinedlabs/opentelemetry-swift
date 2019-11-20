//
//  DistributedContextMock.swift
//
//  Created by Ignacio Bonafonte on 15/11/2019.
//

import Foundation
import OpenTelemetryApi
@testable import OpenTelemetrySdk

class DistributedContextMock: DistributedContext {
    static func contextBuilder() -> DistributedContextBuilder {
        return EmptyDistributedContextBuilder()
    }

    func getEntries() -> [Entry] {
        return [Entry]()
    }

    func getEntryValue(key: EntryKey) -> EntryValue? {
        return nil
    }
}
