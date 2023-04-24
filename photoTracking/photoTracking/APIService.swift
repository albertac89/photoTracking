//
//  Service.swift
//  photoTracking
//
//  Created by Albert Aige Cortasa on 24/4/23.
//

import Combine
import Foundation

protocol APIServiceProtocol {
    func fetchImages(lat: Double, lon: Double) -> AnyPublisher<[FlickrImage], Error>
}

final class APIService {
    private var client: URLSession
    private let host = "https://www.flickr.com/services/rest/"
    private let apiKey = "924a0130c1530820e1815b7b5254d376"
    private let format = "json"
    private let nojsoncallback = 1

    /// Inejcts the dependencies needed for `Service`.
    ///
    /// - Parameters:
    ///     - client: The client to calll the services needed`.
    init(client: URLSession) {
        self.client = client
    }
}

extension APIService: APIServiceProtocol {
    /// Search images from a location
    ///
    /// - Parameters:
    ///     - lat: Latitude`.
    ///     - lon: Longitude`.
    ///     - radius: Radius off the location in km`.
    func fetchImages(lat: Double, lon: Double) -> AnyPublisher<[FlickrImage], Error> {
        let method = "flickr.photos.search"
        let accuracy = 16
        let radius = 0.1
        let radius_units = "km"
        guard var urlComp = URLComponents(string: host) else {
            return Fail(error: APIError.invalidUrl).eraseToAnyPublisher()
        }
        urlComp.queryItems = [
            URLQueryItem(name: "method", value: method),
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "lat", value: String(lat)),
            URLQueryItem(name: "lon", value: String(lon)),
            URLQueryItem(name: "accuracy", value: String(accuracy)),
            URLQueryItem(name: "radius", value: String(radius)),
            URLQueryItem(name: "radius_units", value: radius_units),
            URLQueryItem(name: "format", value: format),
            URLQueryItem(name: "nojsoncallback", value: String(nojsoncallback))
        ]
        guard let url = urlComp.url else {
            return Fail(error: APIError.invalidUrl).eraseToAnyPublisher()
        }
        
        return client.dataTaskPublisher(for: url)
            .tryMap { (data: Data, response: URLResponse) in
                //try self.handleErrors(data: data, response: response)
                return data
            }
            .decode(type: FlickrImageSearchResponse.self, decoder: JSONDecoder())
            .map { $0.photos.photo }
            .share()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

enum APIError: LocalizedError {
    case invalidUrl
    
    var errorDescription: String? {
        switch self {
        case .invalidUrl:
            return "Invalid URL"
        }
    }
}
