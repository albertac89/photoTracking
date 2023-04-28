//
//  DataImageMock.swift
//  photoTrackingTests
//
//  Created by Albert Aige Cortasa on 25/4/23.
//

@testable import photoTracking
import Foundation

struct DataImageMock {
    static var imageData: Data {
        MockedData.forFile(name: "photo", fileExtension: "jpg") ?? Data()
    }
    static var flickrImageMock: [FlickrImage] {
        [FlickrImage(id: "0", secret: "secret0", server: "server0", farm: 0, title: "title0"),
         FlickrImage(id: "1", secret: "secret1", server: "server1", farm: 1, title: "title1"),
         FlickrImage(id: "2", secret: "secret2", server: "server2", farm: 2, title: "title2")]
    }
    static var flickrImageMockService: [FlickrImage] {
        [FlickrImage(id: "0", secret: "secret0", server: "server0", farm: 0, title: "titleService0"),
         FlickrImage(id: "1", secret: "secret1", server: "server1", farm: 1, title: "titleService1"),
         FlickrImage(id: "2", secret: "secret2", server: "server2", farm: 2, title: "titleService2")]
    }
    static var imageModelMock: [ImageModel] {
        [ImageModel(id: "0", imageData: imageData, title: "title0"),
         ImageModel(id: "1", imageData: imageData, title: "title1"),
         ImageModel(id: "2", imageData: imageData, title: "title2")]
    }
    static var imageModelMockService: [ImageModel] {
        [ImageModel(id: "0", imageData: imageData, title: "titleService0"),
         ImageModel(id: "1", imageData: imageData, title: "titleService1"),
         ImageModel(id: "2", imageData: imageData, title: "titleService2")]
    }
}
