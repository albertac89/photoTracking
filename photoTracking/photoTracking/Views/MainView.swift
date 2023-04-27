//
//  ContentView.swift
//  photoTracking
//
//  Created by Albert Aige Cortasa on 24/4/23.
//

import SwiftUI
import Combine

struct MainView<Model>: View where Model: PhotoTrackingViewModelProtocol {
    @ObservedObject var viewModel: Model
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.photoList, id: \.id.self) { image in
                        ImageViewCell(image: image)
                    }
                }
            }
            .navigationTitle("Photo tracking")
            .toolbar {
                Button(viewModel.buttonText) {
                    viewModel.toggleTracking()
                }
                .foregroundColor(.black)
                .fontWeight(.medium)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: PhotoTrackingViewModel(service: APIService(client: URLSession.shared), locationDataManager: LocationDataManager()))
    }
}
