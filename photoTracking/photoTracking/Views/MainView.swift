//
//  ContentView.swift
//  photoTracking
//
//  Created by Albert Aige Cortasa on 24/4/23.
//

import Foundation
import SwiftUI
import Combine

struct MainView<Model>: View where Model: PhotoTrackingViewModelProtocol {
    @ObservedObject var viewModel: Model
    struct Constants {
        static var textTrailingPadding: CGFloat { 8 }
        static var buttonCornerRadius: CGFloat { 10 }
        static var viewShadow: CGFloat { 4 }
    }
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.photoList.isEmpty {
                    VStack {
                        Text("Tap the Start button to get the tracking images and start moving!")
                            .multilineTextAlignment(.center)
                            .fontWeight(.medium)
                            .padding()
                    }
                } else {
                    ScrollView {
                        LazyVStack {
                            ForEach(viewModel.photoList, id: \.id.self) { image in
                                ImageViewCell(image: image).transition(.move(edge: .top))
                            }
                        }.animation(.easeIn, value: viewModel.photoList)
                    }
                }
            }
            .navigationTitle("Photo tracking")
            .toolbar {
                Button(viewModel.isTracking ? "Stop" : "Start") {
                    viewModel.toggleTracking()
                }
                .foregroundColor(.black)
                .fontWeight(.medium)
                .padding(.trailing, Constants.textTrailingPadding)
                .background(viewModel.isTracking ? .red : .green)
                .cornerRadius(Constants.buttonCornerRadius)
                .shadow(radius: Constants.viewShadow)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: PhotoTrackingViewModel(service: APIService(client: URLSession.shared), locationDataManager: LocationDataManager()))
    }
}
