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
    
    func test_fetchImages_toggleTracking_start() throws {
        let sut = try XCTUnwrap(sut)

        XCTAssertTrue(sut.photoList.isEmpty)
        XCTAssertEqual(apiService.fetchImagesCount, 0)
        XCTAssertEqual(locationDataManager.startTrackingCount, 0)
        XCTAssertEqual(locationDataManager.stopTrackingCount, 0)
        sut.toggleTracking()
        XCTAssertEqual(sut.photoList, DataImageMock.imageModelMock.reversed())
        XCTAssertEqual(apiService.fetchImagesCount, 1)
        XCTAssertEqual(locationDataManager.startTrackingCount, 1)
        XCTAssertEqual(locationDataManager.stopTrackingCount, 0)
    }
    
    func test_fetchImages_toggleTracking_stop() throws {
        let sut = try XCTUnwrap(sut)

        sut.toggleTracking()
        XCTAssertEqual(sut.photoList, DataImageMock.imageModelMock.reversed())
        XCTAssertEqual(apiService.fetchImagesCount, 1)
        XCTAssertEqual(locationDataManager.startTrackingCount, 1)
        XCTAssertEqual(locationDataManager.stopTrackingCount, 0)
        sut.toggleTracking()
        XCTAssertEqual(locationDataManager.startTrackingCount, 1)
        XCTAssertEqual(locationDataManager.stopTrackingCount, 1)
    }
    
    //afegir repetits
    func test_fetchImages_toggleTracking_duplicated_photos() throws {
        let sut = try XCTUnwrap(sut)

        XCTAssertTrue(sut.photoList.isEmpty)
        XCTAssertEqual(apiService.fetchImagesCount, 0)
        XCTAssertEqual(locationDataManager.startTrackingCount, 0)
        XCTAssertEqual(locationDataManager.stopTrackingCount, 0)
        sut.toggleTracking() // Start
        sut.toggleTracking() // Stop
        sut.toggleTracking() // Start - as the mock service allways returns the same photos they will be already on the list
        XCTAssertEqual(sut.photoList, DataImageMock.imageModelMock.reversed())
        XCTAssertEqual(apiService.fetchImagesCount, 2)
        XCTAssertEqual(locationDataManager.startTrackingCount, 2)
        XCTAssertEqual(locationDataManager.stopTrackingCount, 1)
    }
}
