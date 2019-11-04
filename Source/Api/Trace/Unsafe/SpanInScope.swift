//
//  SpanInScope.swift
//
//
//  Created by Ignacio Bonafonte on 21/10/2019.
//

import Foundation

import os.activity

struct SpanInScope: Scope {
    
    init(span: Span) {
        ActivityUtils.setActivityForSpan(span: span)
    }

    func close() {
        if let currentSpan = ActivityUtils.getCurrent() {
            ActivityUtils.removeActivityForSpan(span: currentSpan)
        }
    }
}
