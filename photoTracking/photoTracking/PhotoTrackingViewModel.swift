//
//  PhotoTrackingViewModel.swift
//  photoTracking
//
//  Created by Albert Aige Cortasa on 24/4/23.
//

import Combine

protocol PhotoTrackingViewModelProtocol {
    func fetchImages()
}

class PhotoTrackingViewModel {
    private var service: APIServiceProtocol
    private var subscribers = Set<AnyCancellable>()
    
    /// PhotoTracking view model
    ///
    /// - Parameters:
    ///     - service: Api service`.
    init(service: APIServiceProtocol) {
        self.service = service
    }
}

extension PhotoTrackingViewModel: PhotoTrackingViewModelProtocol {
    /// Get images
    func fetchImages() {
        service.fetchImages(lat: 37.337716, lon: -122.009229)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                    break
                }
        } receiveValue: { images in
            print(images)
        }
        .store(in: &subscribers)
    }
}
