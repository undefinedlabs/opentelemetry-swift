//
//  RandomIdsGenerator.swift
//
//
//  Created by Ignacio Bonafonte on 18/11/2019.
//

import Foundation
import OpenTelemetryApi

public struct RandomIdsGenerator: IdsGenerator {
    func generateSpanId() -> SpanId {
        var id: UInt64
        repeat {
            id = UInt64.random(in: .min ... .max)
        } while id == SpanId.invalidId
        return SpanId(id: id)
    }

    func generateTraceId() -> TraceId {
        var idHi: UInt64
        var idLo: UInt64
        repeat {
            idHi = UInt64.random(in: .min ... .max)
            idLo = UInt64.random(in: .min ... .max)
        } while idHi == TraceId.invalidId && idLo == TraceId.invalidId
        return TraceId(idHi: idHi, idLo: idLo)
    }
}
