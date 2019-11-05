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
        ContextUtils.setContextForSpan(span: span)
    }

    func close() {
        if let currentSpan = ContextUtils.getCurrent() {
            ContextUtils.removeContextForSpan(span: currentSpan)
        }
    }
}
