//
//  SpanInScope.swift
//
//
//  Created by Ignacio Bonafonte on 21/10/2019.
//

import Foundation

import ObjectiveC
import os.activity

// Bridging Obj-C variabled defined as c-macroses. See `activity.h` header.
private let OS_ACTIVITY_NONE = unsafeBitCast(dlsym(UnsafeMutableRawPointer(bitPattern: -2), "_os_activity_none"), to: os_activity_t.self)
private let OS_ACTIVITY_CURRENT = unsafeBitCast(dlsym(UnsafeMutableRawPointer(bitPattern: -2), "_os_activity_current"), to: os_activity_t.self)
@_silgen_name("_os_activity_create") private func _os_activity_create(_ dso: UnsafeRawPointer?, _ description: UnsafePointer<Int8>, _ parent : Unmanaged<AnyObject>?, _ flags: os_activity_flag_t) -> AnyObject!
//
//private var activity_state = os_activity_scope_state_s()
//
//private(set) var activityId: os_activity_id_t
//private(set) var activity: os_activity_t

class SpanInScope: Scope {

    var current = os_activity_scope_state_s()

    init(span: Span) {
        let dso = UnsafeMutableRawPointer(mutating: #dsohandle)
        let activity = _os_activity_create(dso, "InitSpan", OS_ACTIVITY_CURRENT, OS_ACTIVITY_FLAG_DEFAULT);
        let activityId =  os_activity_get_identifier(activity, nil)
        os_activity_scope_enter(activity, &current);
        ContextUtils.setContext(activityId: activityId, forSpan: span)
    }

    func close() {
        os_activity_scope_leave(&current)
    }

    deinit {
        close()
    }
}
