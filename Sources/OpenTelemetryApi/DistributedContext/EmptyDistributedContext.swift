//
//  EmptyDistributedContext.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 14/11/2019.
//

import Foundation

public class EmptyDistributedContext: DistributedContext {
    public static var instance = EmptyDistributedContext()

    public static func contextBuilder() -> DistributedContextBuilder {
        return NoopDistributedContextBuilder()
    }
    
    private init() {}

    public func getEntries() -> [Entry] {
        return [Entry]()
    }

    public func getEntryValue(key: EntryKey) -> EntryValue? {
        return nil
    }


}
