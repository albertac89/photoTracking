//
//  PhotoTrackingViewModel.swift
//  photoTracking
//
//  Created by Albert Aige Cortasa on 24/4/23.
//

import Combine
import Foundation
import CoreLocation

protocol PhotoTrackingViewModelProtocol: ObservableObject {
    var photoList: [FlickrImage] { get }
    var buttonText: String { get }
    var isTracking: Bool { get }
    func toggleTracking()
}

class PhotoTrackingViewModel {
    @Published var photoList = [FlickrImage]()
    @Published var buttonText: String = "Start"
    @Published var isTracking: Bool = false
    private var service: APIServiceProtocol
    private var locationDataManager: LocationDataManagerProtocol
    private var serviceSubscribers = Set<AnyCancellable>()
    private var locationManagerSubscribers = Set<AnyCancellable>()
    
    /// PhotoTracking view model
    ///
    /// - Parameters:
    ///     - service: Api service.
    init(service: APIServiceProtocol, locationDataManager: LocationDataManagerProtocol) {
        self.service = service
        self.locationDataManager = locationDataManager
        self.bind(to: locationDataManager)
    }

    deinit {
        unbind()
    }
}

extension PhotoTrackingViewModel: PhotoTrackingViewModelProtocol {
    /// Toggle button action to activate or desactivate the location tracking
    func toggleTracking() {
        if isTracking {
            locationDataManager.stopTracking()
            isTracking = false
        } else {
            isTracking = locationDataManager.startTracking()
        }
        buttonText = isTracking ? "Stop" : "Start"
    }
}

private extension PhotoTrackingViewModel {
    /// Get images from a coordinate
    ///
    /// - Parameters:
    ///     - coordinate: Lat, Lon.
    func fetchImages(with coordinate: CLLocationCoordinate2D) {
        service.fetchImages(lat: coordinate.latitude, lon: coordinate.longitude)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    break
                }
            } receiveValue: { images in
                self.addPhotos(images: images)
            }
            .store(in: &serviceSubscribers)
    }

    /// Load images to the list avoiding duplicates
    ///
    /// - Parameters:
    ///     - images: Images to be added.
    func addPhotos(images: [FlickrImage]) {
        images.forEach { newImage in
            if !photoList.contains(where: { $0.id == newImage.id }) {
                photoList.insert(newImage, at: 0)
            }
        }
    }

    /// Binds the locationDataManager to the view model to handle the changes
    ///
    /// - Parameters:
    ///     - locationDataManager: injected dependecy to bind.
    func bind(to locationDataManager: LocationDataManagerProtocol) {
        locationDataManager.signal
            .sink { [weak self] in self?.handle(state: $0) }
            .store(in: &locationManagerSubscribers)
    }

    /// Remove the subscribers
    func unbind() {
        serviceSubscribers.removeAll()
        locationManagerSubscribers.removeAll()
    }

    /// Handles the location data manager changes that affects this view model
    ///
    /// - Parameters:
    ///     - state: action to be performed.
    func handle(state: LocationDataManagerEventState) {
        switch state {
        case .newLocation(let coordinate):
            fetchImages(with: coordinate)
        case .failure(let error):
            print(error)
        }
    }
}
