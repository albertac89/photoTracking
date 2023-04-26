//
//  LocationDataManager.swift
//  photoTracking
//
//  Created by Albert Aige Cortasa on 24/4/23.
//

import CoreLocation
import Combine

enum LocationDataManagerEventState {
    case newLocation(_ coordinate: CLLocationCoordinate2D)
    case failure(error: Error)
}

protocol LocationDataManagerProtocol {
    var signal: AnyPublisher<LocationDataManagerEventState, Never> { get }
    func startTracking() -> Bool
    func stopTracking()
}

class LocationDataManager: NSObject {
    private var locationManager = CLLocationManager()
    private var authorizationStatus: CLAuthorizationStatus?
    
    private let passthroughSubject = PassthroughSubject<LocationDataManagerEventState, Never>()
    var signal: AnyPublisher<LocationDataManagerEventState, Never> {
        passthroughSubject.eraseToAnyPublisher()
    }
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.distanceFilter = 100
    }
}

extension LocationDataManager: LocationDataManagerProtocol {
    /// Starts tracking the location changes.
    func startTracking() -> Bool {
        if authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            return true
        }
        return false
    }

    /// Stops tracking the location changes.
    func stopTracking() {
        locationManager.stopUpdatingLocation()
    }
}

extension LocationDataManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            authorizationStatus = .authorizedWhenInUse
            break
        case .restricted:
            authorizationStatus = .restricted
            break
        case .denied:
            authorizationStatus = .denied
            break
        case .notDetermined:
            authorizationStatus = .notDetermined
            manager.requestWhenInUseAuthorization()
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.first?.coordinate else { return }
        passthroughSubject.send(.newLocation(coordinate))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        passthroughSubject.send(.failure(error: error))
    }
}
