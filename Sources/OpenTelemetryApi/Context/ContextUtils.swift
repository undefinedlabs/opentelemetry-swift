//
//  SpanActivityUtils.swift
//
//
//  Created by Ignacio Bonafonte on 21/10/2019.
//

import Foundation
import os.activity

/// Helper class to get the current Span and current distributedContext
public struct ContextUtils {

    struct ContextEntry {
        var span: Span?
        var distContext: DistributedContext?
    }
    static let RTLD_DEFAULT = UnsafeMutableRawPointer(bitPattern: -2)
    static let sym = dlsym(RTLD_DEFAULT, "_os_activity_current")
    static let OS_ACTIVITY_CURRENT = unsafeBitCast(sym, to: os_activity_t.self)

    static var contextMap = [os_activity_id_t: ContextEntry]()

    public static func getCurrentSpan() -> Span? {
        let activityIdent = os_activity_get_identifier(OS_ACTIVITY_CURRENT, nil)
        return contextMap[activityIdent]?.span
    }

    public static func getCurrentDistributedContext() -> DistributedContext? {
        let activityIdent = os_activity_get_identifier(OS_ACTIVITY_CURRENT, nil)
        return contextMap[activityIdent]?.distContext
    }

    public static func withSpan(_ span: Span) -> Scope {
        return SpanInScope(span: span)
    }

    public static func withDistributedContext(_ distContext: DistributedContext) -> Scope {
        return DistributedContextInScope(distContext: distContext)
    }

    public static func setContext(activityId: os_activity_id_t, forSpan span: Span) {
        if contextMap[activityId] != nil {
            contextMap[activityId]!.span = span
        } else {
            contextMap[activityId] = ContextEntry(span: span, distContext: getCurrentDistributedContext())
        }
    }

    public static func setContext(activityId: os_activity_id_t, forDistributedContext distContext: DistributedContext) {
        if contextMap[activityId] != nil {
            contextMap[activityId]!.distContext = distContext
        } else {
            contextMap[activityId] = ContextEntry(span: getCurrentSpan(), distContext: distContext)
        }
    }
}
