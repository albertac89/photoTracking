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
}
