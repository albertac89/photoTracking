//
//  URLSessionMock.swift
//  photoTrackingTests
//
//  Created by Albert Aige Cortasa on 25/4/23.
//

import Foundation

final class URLSessionMock {
    static var mock: URLSession {
        let configurationWithMock = URLSessionConfiguration.default
        configurationWithMock.protocolClasses = [URLProtocolMock.self]
        return URLSession(configuration: configurationWithMock)
    }
}
