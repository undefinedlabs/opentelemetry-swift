//
//  File.swift
//  
//
//  Created by Ignacio Bonafonte on 17/10/2019.
//

import Foundation

enum SpanAttributeConstants: String
{
    case httpMethodKey = "http.method"
    case httpStatusCodeKey = "http.status_code"
    case httpUserAgentKey = "http.user_agent"
    case httpPathKey = "http.path"
    case httpHostKey = "http.host"
    case httpUrlKey = "http.url"
    case httpRequestSizeKey = "http.request.size"
    case httpResponseSizeKey = "http.response.size"
    case httpRouteKey = "http.route"
}
