//
//  ImageCell.swift
//  photoTracking
//
//  Created by Albert Aige Cortasa on 25/4/23.
//

import Foundation

import SwiftUI
import Combine

struct ImageViewCell: View {
    var image: FlickrImage
    var body: some View {
        VStack {
            AsyncImage(url: image.url)
            Text(image.title)
        }
    }
}
