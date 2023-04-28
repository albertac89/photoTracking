//
//  APIServiceTests.swift
//  photoTrackingTests
//
//  Created by Albert Aige Cortasa on 25/4/23.
//

import XCTest
import Combine
@testable import photoTracking

final class APIServiceTests: XCTestCase {
    private var sut: APIService?
    private let client = URLSessionMock.mock
    private var cancellables: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        URLProtocol.registerClass(URLProtocolMock.self)
        guard let accountsListMock = MockedData.forFile(name: "photos") else {
            XCTFail("Mock response not loaded")
            return
        }
        guard let photoMock = MockedData.forFile(name: "photo", fileExtension: "jpg") else {
            XCTFail("Mock image not loaded")
            return
        }
        URLProtocolMock.mockData["/services/rest"] = accountsListMock
        DataImageMock.flickrImageMockService.forEach {photo in
            if let path = photo.url?.relativePath {
                URLProtocolMock.mockData[path] = photoMock
            }
        }
        sut = APIService(client: client)
    }

    override func tearDownWithError() throws {
        sut = nil
        cancellables = []
    }
    
    func test_fetchImages() throws {
        let sut = try XCTUnwrap(sut)
        let expectation = XCTestExpectation()
        
        var photos = [FlickrImage]()
        sut.fetchImages(lat: LocationDataManagerMock.coordinate.latitude, lon: LocationDataManagerMock.coordinate.longitude)
            .sink { completion in
                expectation.fulfill()
            } receiveValue: { photosMock in
                photos = photosMock
            }.store(in: &cancellables)

        wait(for: [expectation], timeout: 1)
        
        XCTAssertEqual(photos, DataImageMock.flickrImageMockService)
    }
    
    func test_downloadImagePublisher() throws {
        let sut = try XCTUnwrap(sut)
        let expectation = XCTestExpectation()
        let fetchImagesPublisher = sut.fetchImages(lat: LocationDataManagerMock.coordinate.latitude,
                                                   lon: LocationDataManagerMock.coordinate.longitude)
        let downloadImagePublisher = sut.downloadImagePublisher(fetchImagesPublisher: fetchImagesPublisher)
        
        var photos = [ImageModel]()
        downloadImagePublisher.sink { completion in
            expectation.fulfill()
        } receiveValue: { photosMock in
            photos = photosMock
        }.store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
        
        XCTAssertEqual(photos, DataImageMock.imageModelMockService)
    }
}
