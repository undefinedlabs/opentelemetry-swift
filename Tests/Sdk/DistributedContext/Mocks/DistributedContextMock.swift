//
//  DistributedContextMock.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 15/11/2019.
//

@testable import OpenTelemetrySwift
import Foundation

class DistributedContextMock: DistributedContext {

    static func contextBuilder() -> DistributedContextBuilder {
        return NoopDistributedContextBuilder()
    }

    func getEntries() -> [Entry] {
        return [Entry]()
    }

    func getEntryValue(key: EntryKey) -> EntryValue? {
        return nil
    }

}
