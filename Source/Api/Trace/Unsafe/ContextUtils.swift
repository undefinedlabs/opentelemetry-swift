//
//  SpanActivityUtils.swift
//
//
//  Created by Ignacio Bonafonte on 21/10/2019.
//

import Foundation
import os.activity

struct ContextUtils {

    static let RTLD_DEFAULT = UnsafeMutableRawPointer(bitPattern: -2)
    static let sym = dlsym(RTLD_DEFAULT, "_os_activity_current")
    static let OS_ACTIVITY_CURRENT = unsafeBitCast(sym, to: os_activity_t.self)

    static var spanActivityMap = [os_activity_id_t: Span]()

    static func getCurrent() -> Span? {
        if #available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *) {
            let activityIdent = os_activity_get_identifier(OS_ACTIVITY_CURRENT, nil)
            return spanActivityMap[activityIdent]
        } else {
            return nil
        }
    }

    static func withSpan(span: Span) -> Scope {
        return SpanInScope(span: span)
    }

    static func setContextForSpan(span:Span) {
        spanActivityMap[span.context.activityId] = span
    }

    static func removeContextForSpan(span:Span) {
        spanActivityMap[span.context.activityId] = nil
    }
}
