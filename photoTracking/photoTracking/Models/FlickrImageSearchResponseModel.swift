//
//  Model.swift
//  photoTracking
//
//  Created by Albert Aige Cortasa on 24/4/23.
//

import Foundation

struct FlickrImageSearchResponse: Codable {
    let photos: Photos
}

struct Photos: Codable {
    let photo: [FlickrImage]
}

struct FlickrImage: Codable, Equatable {
    let id: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    var url: URL? {
        URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg")
    }
}
