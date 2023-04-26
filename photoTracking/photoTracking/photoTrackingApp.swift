//
//  photoTrackingApp.swift
//  photoTracking
//
//  Created by Albert Aige Cortasa on 24/4/23.
//

import SwiftUI

@main
struct photoTrackingApp: App {
    var body: some Scene {
        WindowGroup {
            MainView(viewModel: PhotoTrackingViewModel(service: APIService(client: URLSession.shared), locationDataManager: LocationDataManager()))
        }
    }
}
