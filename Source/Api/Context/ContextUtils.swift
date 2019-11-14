//
//  SpanActivityUtils.swift
//
//
//  Created by Ignacio Bonafonte on 21/10/2019.
//

import Foundation
import os.activity

struct ContextEntry {
    var span: Span?
    var distContext: DistributedContext?
}

struct ContextUtils {
    static let RTLD_DEFAULT = UnsafeMutableRawPointer(bitPattern: -2)
    static let sym = dlsym(RTLD_DEFAULT, "_os_activity_current")
    static let OS_ACTIVITY_CURRENT = unsafeBitCast(sym, to: os_activity_t.self)

    static var contextMap = [os_activity_id_t: ContextEntry]()

    static func getCurrentSpan() -> Span? {
        if #available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *) {
            let activityIdent = os_activity_get_identifier(OS_ACTIVITY_CURRENT, nil)
            return contextMap[activityIdent]?.span
        } else {
            return nil
        }
    }

    static func getCurrentDistributedContext() -> DistributedContext? {
        if #available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *) {
            let activityIdent = os_activity_get_identifier(OS_ACTIVITY_CURRENT, nil)
            return contextMap[activityIdent]?.distContext
        } else {
            return nil
        }
    }

    static func withSpan(_ span: Span) -> Scope {
        return SpanInScope(span: span)
    }

    static func withDistributedContext(_ distContext: DistributedContext) -> Scope {
        return DistributedContextInScope(distContext: distContext)
    }

    static func setContext(activityId: os_activity_id_t, forSpan span: Span) {
        if contextMap[activityId] != nil {
            contextMap[activityId]!.span = span
        } else {
            contextMap[activityId] = ContextEntry(span: span, distContext: nil)
        }
    }

    static func setContext(activityId: os_activity_id_t, forDistributedContext distContext: DistributedContext) {
        if contextMap[activityId] != nil {
            contextMap[activityId]!.distContext = distContext
        } else {
            contextMap[activityId] = ContextEntry(span: nil, distContext: distContext)
        }
    }
}
