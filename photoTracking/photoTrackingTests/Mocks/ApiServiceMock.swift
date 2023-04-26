//
//  ApiServiceMock.swift
//  photoTrackingTests
//
//  Created by Albert Aige Cortasa on 25/4/23.
//

@testable import photoTracking
import Combine

final class ApiServiceMock: APIServiceProtocol {
    var fetchImagesCount = 0
    func fetchImages(lat: Double, lon: Double) -> AnyPublisher<[FlickrImage], Error> {
        fetchImagesCount += 1
        return Just(FlickrImageMock.array).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
