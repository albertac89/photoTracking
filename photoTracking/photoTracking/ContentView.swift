//
//  ContentView.swift
//  photoTracking
//
//  Created by Albert Aige Cortasa on 24/4/23.
//

import SwiftUI
import Combine

struct ContentView: View {
    let viewModel = PhotoTrackingViewModel(service: APIService(client: URLSession.shared))
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
        .onAppear(perform: viewModel.fetchImages)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
