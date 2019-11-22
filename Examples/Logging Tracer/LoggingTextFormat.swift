//
//  LoggingTextFormat.swift
//  //
//  Created by Ignacio Bonafonte on 19/11/2019.
//

import Foundation
import OpenTelemetryApi

class LoggingTextFormat: TextFormattable {
    var fields = Set<String>()

    func inject<S>(spanContext: SpanContext, carrier: inout [String : String], setter: S) where S : Setter {
        Logger.log("LoggingTextFormat.Inject(\(spanContext), ...)");

    }

    func extract<G>(carrier: [String : String], getter: G) -> SpanContext? where G : Getter {
        Logger.log("LoggingTextFormat.Extract(...)");
        return SpanContext.invalid;
    }


}
