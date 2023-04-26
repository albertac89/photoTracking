//
//  URLProtocolMock.swift
//  photoTrackingTests
//
//  Created by Albert Aige Cortasa on 25/4/23.
//

import Foundation

final class URLProtocolMock: URLProtocol {
    static var mockData = [String: Data]()
    
    override class func canInit(with task: URLSessionTask) -> Bool {
        return true
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let url = request.url {
            let path = url.relativePath
            if let data = URLProtocolMock.mockData[path] {
                client?.urlProtocol(self, didLoad: data)
                client?.urlProtocol(self, didReceive: HTTPURLResponse(), cacheStoragePolicy: .allowed)
            } else {
                client?.urlProtocol(self, didFailWithError: MockAPIError.errorLoadingJson)
            }
        }
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {}
}

enum MockAPIError: LocalizedError {
    case errorLoadingJson
    
    var errorDescription: String? {
        switch self {
        case .errorLoadingJson:
            return "Error loading json file"
        }
    }
}

final class MockedData {
    static func forFile(name: String, fileExtension: String = "json") -> Data? {
        if let url = Bundle(for: self).url(forResource: name, withExtension: fileExtension) {
            do {
                let data = try Data(contentsOf: url)
                return data
            } catch {
                print("Mocking data error:\(error)")
            }
        }
        return nil
    }
}
