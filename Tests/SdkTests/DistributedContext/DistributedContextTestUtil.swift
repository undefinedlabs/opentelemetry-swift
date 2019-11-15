//
//  DistributedContextTestUtil.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 15/11/2019.
//

@testable import Sdk
import Api
import Foundation

struct DistributedContextTestUtil {
    static func listToDistributedContext(entries: [Entry]) -> DistributedContextSdk {
        let builder = DistributedContextSdk.contextBuilder()
        for entry in entries {
            builder.put(key: entry.key, value: entry.value, metadata: entry.metadata)
        }
        return builder.build() as! DistributedContextSdk
    }
}
