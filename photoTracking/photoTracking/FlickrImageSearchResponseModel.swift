//
//  Model.swift
//  photoTracking
//
//  Created by Albert Aige Cortasa on 24/4/23.
//

struct FlickrImageSearchResponse: Codable {
    let photos: Photos
}

struct Photos: Codable {
    let photo: [FlickrImage]
}

struct FlickrImage: Codable {
    let id: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
}
