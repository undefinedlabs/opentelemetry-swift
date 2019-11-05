//
//  Span.swift
//
//
//  Created by Ignacio Bonafonte on 14/10/2019.
//

import Foundation

public protocol Span: AnyObject, CustomStringConvertible {
    /// <summary>
    /// Gets the span context.
    /// </summary>
    var context: SpanContext { get }

    /// <summary>
    /// Gets a value indicating whether this span will be recorded.
    /// </summary>
    var IsRecordingEvents: Bool { get }

    /// <summary>
    /// Sets the status of the span execution.
    /// </summary>
    var status: Status? { get set }

    /// <summary>
    /// Updates the <see cref="ISpan"/> name.
    ///
    /// If used, this will override the name provided via StartSpan method overload.
    /// Upon this update, any sampling behavior based on <see cref="ISpan"/> name will depend on the
    /// implementation.
    /// </summary>
    /// <param name="name">Name of the span.</param>
    func updateName(name: String)

    /// <summary>
    /// Puts a new attribute to the span.
    /// </summary>
    /// <param name="key">Key of the attribute.</param>
    /// <param name="value">Attribute value.</param>
    func setAttribute(key: String, value: String)

    /// <summary>
    /// Puts a new attribute to the span.
    /// </summary>
    /// <param name="key">Key of the attribute.</param>
    /// <param name="value">Attribute value.</param>
    func setAttribute(key: String, value: Int)

    /// <summary>
    /// Puts a new attribute to the span.
    /// </summary>
    /// <param name="key">Key of the attribute.</param>
    /// <param name="value">Attribute value.</param>
    func setAttribute(key: String, value: Double)

    /// <summary>
    /// Puts a new attribute to the span.
    /// </summary>
    /// <param name="key">Key of the attribute.</param>
    /// <param name="value">Attribute value.</param>
    func setAttribute(key: String, value: Bool)

    func setAttribute(key: String, value: AttributeValue)

    /// <summary>
    /// Adds a single <see cref="Event"/> to the <see cref="ISpan"/>.
    /// </summary>
    /// <param name="name">Name of the <see cref="Event"/>.</param>
    func addEvent(name: String)

    /// <summary>
    /// Adds a single <see cref="Event"/> with the <see cref="IDictionary{String, IAttributeValue}"/> attributes to the <see cref="ISpan"/>.
    /// </summary>
    /// <param name="name">Event name.</param>
    /// <param name="attributes"><see cref="IDictionary{String, IAttributeValue}"/> of attributes name/value pairs associated with the <see cref="Event"/>.</param>
    func addEvent(name: String, attributes: [String: AttributeValue])

    /// <summary>
    /// Adds an <see cref="Event"/> object to the <see cref="ISpan"/>.
    /// </summary>
    /// <param name="newEvent"><see cref="Event"/> to add to the span.</param>
    func addEvent<E: Event>(event: E)

    /// <summary>
    /// End the span.
    /// </summary>
    func end()

    /// <summary>
    /// End the span.
    /// </summary>
    /// <param name="endTimestamp">End timestamp.</param>
    func end(timestamp: Timestamp)
}

extension Span {
    /// <summary>
    /// Helper method that populates span properties from http method according
    /// to https://github.com/open-telemetry/OpenTelemetry-specs/blob/4954074adf815f437534457331178194f6847ff9/trace/HTTP.md.
    /// </summary>
    /// <param name="method">Http method.</param>
    /// <returns>Span with populated http method properties.</returns>
    public func putHttpMethodAttribute(method: String) {
        setAttribute(key: SpanAttributeConstants.httpMethodKey.rawValue, value: method)
    }

    /// <summary>
    /// Helper method that populates span properties from http status code according
    /// to https://github.com/open-telemetry/OpenTelemetry-specs/blob/4954074adf815f437534457331178194f6847ff9/trace/HTTP.md.
    /// </summary>
    /// <param name="span">Span to fill out.</param>
    /// <param name="statusCode">Http status code.</param>
    /// <returns>Span with populated status code properties.</returns>
    public func putHttpStatusCodeAttribute(statusCode: Int) {
        setAttribute(key: SpanAttributeConstants.httpStatusCodeKey.rawValue, value: statusCode)
    }

    /// <summary>
    /// Helper method that populates span properties from http user agent according
    /// to https://github.com/open-telemetry/OpenTelemetry-specs/blob/4954074adf815f437534457331178194f6847ff9/trace/HTTP.md.
    /// </summary>
    /// <param name="span">Span to fill out.</param>
    /// <param name="userAgent">Http status code.</param>
    /// <returns>Span with populated user agent code properties.</returns>
    public func putHttpUserAgentAttribute(userAgent: String) {
        if userAgent != " " {
            setAttribute(key: SpanAttributeConstants.httpUserAgentKey.rawValue, value: userAgent)
        }
    }

    /// <summary>
    /// Helper method that populates span properties from host and port
    /// to https://github.com/open-telemetry/OpenTelemetry-specs/blob/4954074adf815f437534457331178194f6847ff9/trace/HTTP.md.
    /// </summary>
    /// <param name="span">Span to fill out.</param>
    /// <param name="hostName">Hostr name.</param>
    /// <param name="port">Port number.</param>
    /// <returns>Span with populated host properties.</returns>
    public func putHttpHostAttribute(string hostName: String, int port: Int) {
        if port == 80 || port == 443 {
            setAttribute(key: SpanAttributeConstants.httpHostKey.rawValue, value: hostName)
        } else {
            setAttribute(key: SpanAttributeConstants.httpHostKey.rawValue, value: "\(hostName):\(port)")
        }
    }

    /// <summary>
    /// Helper method that populates span properties from route
    /// to https://github.com/open-telemetry/OpenTelemetry-specs/blob/4954074adf815f437534457331178194f6847ff9/trace/HTTP.md.
    /// </summary>
    /// <param name="span">Span to fill out.</param>
    /// <param name="route">Route used to resolve url to controller.</param>
    /// <returns>Span with populated route properties.</returns>
    public func putHttpRouteAttribute(route: String) {
        if !route.isEmpty {
            setAttribute(key: SpanAttributeConstants.httpRouteKey.rawValue, value: route)
        }
    }

    /// <summary>
    /// Helper method that populates span properties from host and port
    /// to https://github.com/open-telemetry/OpenTelemetry-specs/blob/4954074adf815f437534457331178194f6847ff9/trace/HTTP.md.
    /// </summary>
    /// <param name="span">Span to fill out.</param>
    /// <param name="rawUrl">Raw url.</param>
    /// <returns>Span with populated url properties.</returns>
    public func putHttpRawUrlAttribute(rawUrl: String) {
        if !rawUrl.isEmpty {
            setAttribute(key: SpanAttributeConstants.httpUrlKey.rawValue, value: rawUrl)
        }
    }

    /// <summary>
    /// Helper method that populates span properties from url path according
    /// to https://github.com/open-telemetry/OpenTelemetry-specs/blob/4954074adf815f437534457331178194f6847ff9/trace/HTTP.md.
    /// </summary>
    /// <param name="span">Span to fill out.</param>
    /// <param name="path">Url path.</param>
    /// <returns>Span with populated path properties.</returns>
    public func putHttpPathAttribute(path: String) {
        setAttribute(key: SpanAttributeConstants.httpPathKey.rawValue, value: path)
    }

    /// <summary>
    /// Helper method that populates span properties from size according
    /// to https://github.com/open-telemetry/OpenTelemetry-specs/blob/4954074adf815f437534457331178194f6847ff9/trace/HTTP.md.
    /// </summary>
    /// <param name="span">Span to fill out.</param>
    /// <param name="size">Response size.</param>
    /// <returns>Span with populated response size properties.</returns>
    public func putHttpResponseSizeAttribute(size: Int) {
        setAttribute(key: SpanAttributeConstants.httpResponseSizeKey.rawValue, value: size)
    }

    /// <summary>
    /// Helper method that populates span properties from request size according
    /// to https://github.com/open-telemetry/OpenTelemetry-specs/blob/4954074adf815f437534457331178194f6847ff9/trace/HTTP.md.
    /// </summary>
    /// <param name="span">Span to fill out.</param>
    /// <param name="size">Request size.</param>
    /// <returns>Span with populated request size properties.</returns>
    public func putHttpRequestSizeAttribute(size: Int) {
        setAttribute(key: SpanAttributeConstants.httpRequestSizeKey.rawValue, value: size)
    }

    /// <summary>
    /// Helper method that populates span properties from http status code according
    /// to https://github.com/open-telemetry/OpenTelemetry-specs/blob/4954074adf815f437534457331178194f6847ff9/trace/HTTP.md.
    /// </summary>
    /// <param name="span">Span to fill out.</param>
    /// <param name="statusCode">Http status code.</param>
    /// <param name="reasonPhrase">Http reason phrase.</param>
    /// <returns>Span with populated properties.</returns>
    public func putHttpStatusCode(statusCode: Int, reasonPhrase: String) {
        putHttpStatusCodeAttribute(statusCode: statusCode)
        var newStatus: Status = .ok
        switch statusCode {
        case 200 ..< 400:
            newStatus = .ok
        case 400:
            newStatus = .invalid_argument
        case 403:
            newStatus = .permission_denied
        case 404:
            newStatus = .not_found
        case 429:
            newStatus = .resource_exhausted
        case 501:
            newStatus = .unimplemented
        case 503:
            newStatus = .unavailable
        case 504:
            newStatus = .deadline_exceeded
        default:
            newStatus = .unknown
        }
        status = newStatus.withDescription(description: reasonPhrase)
    }
}
