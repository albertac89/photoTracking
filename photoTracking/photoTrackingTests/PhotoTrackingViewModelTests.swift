//
//  PhotoTrackingViewModelTests.swift
//  photoTrackingTests
//
//  Created by Albert Aige Cortasa on 25/4/23.
//

import XCTest
@testable import photoTracking

final class PhotoTrackingViewModelTests: XCTestCase {
    private let apiService = ApiServiceMock()
    private let locationDataManager = LocationDataManagerMock()
    private var sut: PhotoTrackingViewModel?
    
    override func setUpWithError() throws {
        sut = PhotoTrackingViewModel(service: apiService, locationDataManager: locationDataManager)
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_toggleTracking() throws {
        let sut = try XCTUnwrap(sut)

        XCTAssertEqual(sut.buttonText, "Start")
        sut.toggleTracking()
        XCTAssertEqual(sut.buttonText, "Stop")
        sut.toggleTracking()
        XCTAssertEqual(sut.buttonText, "Start")
    }
    
    func test_fetchImages() throws {
        let sut = try XCTUnwrap(sut)

        XCTAssertTrue(sut.photoList.isEmpty)
        XCTAssertEqual(apiService.fetchImagesCount, 0)
        sut.fetchImages(with: LocationDataManagerMock.coordinate)
        XCTAssertEqual(sut.photoList, FlickrImageMock.array.reversed())
        XCTAssertEqual(apiService.fetchImagesCount, 1)
    }
}
