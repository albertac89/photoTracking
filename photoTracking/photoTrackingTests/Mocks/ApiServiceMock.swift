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
    var downloadImagePublisher = 0

    func fetchImages(lat: Double, lon: Double) -> AnyPublisher<[FlickrImage], Error> {
        fetchImagesCount += 1
        return Just(DataImageMock.flickrImageMock).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func downloadImagePublisher(fetchImagesPublisher: AnyPublisher<[FlickrImage], Error>) -> AnyPublisher<Publishers.Collect<Publishers.MergeMany<AnyPublisher<ImageModel, Error>>>.Output, Error> {
        downloadImagePublisher += 1
        return Just(DataImageMock.imageModelMock).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
