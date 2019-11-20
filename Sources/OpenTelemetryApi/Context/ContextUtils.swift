//
//  SpanActivityUtils.swift
//
//  Created by Ignacio Bonafonte on 21/10/2019.
//

import Foundation
import os.activity

/// Helper class to get the current Span and current distributedContext
/// Users must interact with the current Context via the public APIs in Tracer and avoid
/// accessing this class directly.
public struct ContextUtils {

    struct ContextEntry {
        var span: Span?
        var distContext: DistributedContext?
    }
    static let RTLD_DEFAULT = UnsafeMutableRawPointer(bitPattern: -2)
    static let sym = dlsym(RTLD_DEFAULT, "_os_activity_current")
    static let OS_ACTIVITY_CURRENT = unsafeBitCast(sym, to: os_activity_t.self)

    static var contextMap = [os_activity_id_t: ContextEntry]()

    /// Returns the Span from the current context
    public static func getCurrentSpan() -> Span? {
        let activityIdent = os_activity_get_identifier(OS_ACTIVITY_CURRENT, nil)
        return contextMap[activityIdent]?.span
    }

    /// Returns the DistributedContext from the current context
    public static func getCurrentDistributedContext() -> DistributedContext? {
        let activityIdent = os_activity_get_identifier(OS_ACTIVITY_CURRENT, nil)
        return contextMap[activityIdent]?.distContext
    }

    /// Returns a new Scope encapsulating the provided Span added to the current context
    /// - Parameter span: the Span to be added to the current context
    public static func withSpan(_ span: Span) -> Scope {
        return SpanInScope(span: span)
    }

    /// Returns a new Scope encapsulating the provided Distributed Context added to the current context
    /// - Parameter distContext: the Distributed Context to be added to the current contex
    public static func withDistributedContext(_ distContext: DistributedContext) -> Scope {
        return DistributedContextInScope(distContext: distContext)
    }

    static func setContext(activityId: os_activity_id_t, forSpan span: Span) {
        if contextMap[activityId] != nil {
            contextMap[activityId]!.span = span
        } else {
            contextMap[activityId] = ContextEntry(span: span, distContext: getCurrentDistributedContext())
        }
    }

    static func setContext(activityId: os_activity_id_t, forDistributedContext distContext: DistributedContext) {
        if contextMap[activityId] != nil {
            contextMap[activityId]!.distContext = distContext
        } else {
            contextMap[activityId] = ContextEntry(span: getCurrentSpan(), distContext: distContext)
        }
    }
}
