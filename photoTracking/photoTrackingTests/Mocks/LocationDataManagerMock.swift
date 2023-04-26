//
//  LocationDataManagerMock.swift
//  photoTrackingTests
//
//  Created by Albert Aige Cortasa on 25/4/23.
//

@testable import photoTracking
import Combine
import CoreLocation

final class LocationDataManagerMock: LocationDataManagerProtocol {
    var startTrackingCount = 0
    var stopTrackingCount = 0
    static let coordinate = CLLocationCoordinate2D(latitude: 37.337760, longitude: -122.012969)
    private let passthroughSubject = PassthroughSubject<LocationDataManagerEventState, Never>()
    var signal: AnyPublisher<LocationDataManagerEventState, Never> {
        passthroughSubject.eraseToAnyPublisher()
    }
    
    func startTracking() -> Bool {
        startTrackingCount += 1
        passthroughSubject.send(.newLocation(LocationDataManagerMock.coordinate))
        return true
    }
    
    func stopTracking() {
        stopTrackingCount += 1
    }
}
