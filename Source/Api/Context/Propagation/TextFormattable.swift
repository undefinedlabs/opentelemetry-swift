//
//  TextFormattable.swift
//  
//
//  Created by Ignacio Bonafonte on 15/10/2019.
//

import Foundation

public protocol TextFormattable
{
    /// <summary>
    /// Gets the list of headers used by propagator. The use cases of this are:
    ///   * allow pre-allocation of fields, especially in systems like gRPC Metadata
    ///   * allow a single-pass over an iterator (ex OpenTracing has no getter in TextMap).
    /// </summary>
    var fields: Set<String>  { get }

    /// <summary>
    /// Injects textual representation of span context to transmit over the wire.
    /// </summary>
    /// <typeparam name="T">Type of an object to set context on. Typically HttpRequest or similar.</typeparam>
    /// <param name="spanContext">Span context to transmit over the wire.</param>
    /// <param name="carrier">Object to set context on. Instance of this object will be passed to setter.</param>
    /// <param name="setter">Action that will set name and value pair on the object.</param>
    func inject<S: Setter>( spanContext: SpanContext, carrier: inout [String: String], setter: S);

    /// <summary>
    /// Extracts span context from textual representation.
    /// </summary>
    /// <typeparam name="T">Type of object to extract context from. Typically HttpRequest or similar.</typeparam>
    /// <param name="carrier">Object to extract context from. Instance of this object will be passed to the getter.</param>
    /// <param name="getter">Function that will return string value of a key with the specified name.</param>
    /// <returns>Span context from it's text representation.</returns>
    func extract<G: Getter>( carrier: [String: String], getter: G) -> SpanContext?
}

public protocol Setter {
    func set( carrier: inout [String: String], key: String, value: String)
}
public protocol Getter {
    func get(carrier:[String: String], key: String)-> [String]?
}


