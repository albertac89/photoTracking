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
    func downloadImagePublisher(fetchImagesPublisher: AnyPublisher<[FlickrImage], Error>) -> AnyPublisher<Publishers.Collect<Publishers.MergeMany<AnyPublisher<ImageModel, any Error>>>.Output, any Error>
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
    ///     - lat: Latitude.
    ///     - lon: Longitude.
    ///     - radius: Radius off the location in km.
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
                try self.handleErrors(data: data, response: response)
                return data
            }
            .decode(type: FlickrImageSearchResponse.self, decoder: JSONDecoder())
            .map { $0.photos.photo }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    /// Creates a publisher
    ///
    /// - Parameters:
    ///     - fetchImagesPublisher: The publisher that got the images data.
    func downloadImagePublisher(fetchImagesPublisher: AnyPublisher<[FlickrImage], Error>) -> AnyPublisher<Publishers.Collect<Publishers.MergeMany<AnyPublisher<ImageModel, any Error>>>.Output, any Error> {
        return fetchImagesPublisher
            .flatMap { images in
                return Publishers.Zip(Just(images).setFailureType(to: Error.self),
                                      Publishers.MergeMany(images.map { self.downloadImage(for: $0) }).collect())
            }
            .map {
                return $0.1
            }
            .eraseToAnyPublisher()
    }
}

private extension APIService {
    /// Downloads an image from an url
    ///
    /// - Parameters:
    ///     - image: An image with all the necesary data to be downloaded.
    func downloadImage(for image: FlickrImage) -> AnyPublisher<ImageModel, Error> {
        guard let stringUrl = image.url?.absoluteString, let url = URL(string: stringUrl) else {
            return Fail(error: APIError.invalidUrl).eraseToAnyPublisher()
        }
        return client.dataTaskPublisher(for: url)
            .tryMap { (data: Data, response: URLResponse) in
                try self.handleErrors(data: data, response: response)
                return data
            }
            .compactMap { ImageModel(id: image.id, imageData: $0, title: image.title) }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    /// Checks whether there is an error with the service response and throws an error if needed.
    ///
    /// - Parameters:
    ///     - data: The `Data`from the service.
    ///     - response: `URLResponse` from the service.
    func handleErrors(data: Data, response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        let apiError = try? decoder.decode(ErrorResponseModel.self, from: data)
        if let error = apiError, error.stat == "fail" {
            throw APIError.errorMessage(error.message)
        }
    }
}

enum APIError: LocalizedError {
    case invalidUrl
    case invalidResponse
    case errorMessage(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidUrl:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response"
        case .errorMessage(let message):
            return message
        }
    }
}
