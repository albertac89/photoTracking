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
        URLProtocolMock.mockData["/services/rest"] = accountsListMock
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
        
        XCTAssertEqual(photos, FlickrImageMock.arrayService)
    }
    
    func test_downloadImagePublisher() throws {
        //https://farm2.staticflickr.com/1526/24947572265_43208b06a0.jpg
        //staticflickr
        //cridar al la url aqui directament amb urlsession del apiservice i veure com arreglau
        let sut = try XCTUnwrap(sut)
        let expectation = XCTestExpectation()
        let fetchImagesPublisher = sut.fetchImages(lat: LocationDataManagerMock.coordinate.latitude, lon: LocationDataManagerMock.coordinate.longitude)
        
        var photos = [ImageModel]()
        sut.downloadImagePublisher(fetchImagesPublisher: fetchImagesPublisher)
            .sink { completion in
                expectation.fulfill()
            } receiveValue: { photosMock in
                photos = photosMock
            }.store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5)
        
        XCTAssertEqual(photos, ImageModelMock.arrayService)
    }
}
