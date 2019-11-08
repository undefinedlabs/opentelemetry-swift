//
//  SpanExporterMock.swift
//  OpenTelemetrySwift
//
//  Created by Ignacio Bonafonte on 08/11/2019.
//

@testable import OpenTelemetrySwift
import Foundation

class SpanExporterMock: SpanExporter {

    var exportCalledTimes: Int = 0
//    var exportCalledData: [SpanData]?
    var shutdownCalledTimes: Int = 0
    var returnValue: SpanExporterResultCode = .success

    func export(spans: [SpanData]) -> SpanExporterResultCode {
        exportCalledTimes += 1
//        exportCalledData = spans
        return returnValue
    }

    func shutdown() {
        shutdownCalledTimes += 1
    }

}
