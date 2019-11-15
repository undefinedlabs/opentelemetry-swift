//
//  EmptyDistributedContext.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 14/11/2019.
//

import Foundation

class EmptyDistributedContext: DistributedContext {
    static var instance = EmptyDistributedContext()

    static func contextBuilder() -> DistributedContextBuilder {
        return NoopDistributedContextBuilder()
    }
    
    private init() {}

    func getEntries() -> [Entry] {
        return [Entry]()
    }

    func getEntryValue(key: EntryKey) -> EntryValue? {
        return nil
    }


}
