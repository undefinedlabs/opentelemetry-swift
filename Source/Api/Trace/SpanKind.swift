//
//  SpanKind.swift
//  
//
//  Created by Ignacio Bonafonte on 15/10/2019.
//

import Foundation

public enum SpanKind {
    /**
     * Default value. Indicates that the span is used internally.
     *
     * @since 0.1.0
     */

    case `internal`

    /**
     * Indicates that the span covers server-side handling of an RPC or other remote request.
     *
     * @since 0.1.0
     */
    case server

    /**
     * Indicates that the span covers the client-side wrapper around an RPC or other remote request.
     *
     * @since 0.1.0
     */
    case client

    /**
     * Indicates that the span describes producer sending a message to a broker. Unlike client and
     * server, there is no direct critical path latency relationship between producer and consumer
     * spans.
     *
     * @since 0.1.0
     */
    case producer

    /**
     * Indicates that the span describes consumer receiving a message from a broker. Unlike client
     * and server, there is no direct critical path latency relationship between producer and
     * consumer spans.
     *
     * @since 0.1.0
     */
    case consumer
}
