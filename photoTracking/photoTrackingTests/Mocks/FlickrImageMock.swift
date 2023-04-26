//
//  FlickrImageMock.swift
//  photoTrackingTests
//
//  Created by Albert Aige Cortasa on 25/4/23.
//

@testable import photoTracking

struct FlickrImageMock {
    static var array: [FlickrImage] {
        [FlickrImage(id: "0", secret: "secret0", server: "server0", farm: 0, title: "title0"),
         FlickrImage(id: "1", secret: "secret1", server: "server1", farm: 1, title: "title1"),
         FlickrImage(id: "2", secret: "secret2", server: "server2", farm: 2, title: "title2")]
    }
    
    static var arrayService: [FlickrImage] {
        [FlickrImage(id: "0", secret: "secret0", server: "server0", farm: 0, title: "titleService0"),
         FlickrImage(id: "1", secret: "secret1", server: "server1", farm: 1, title: "titleService1"),
         FlickrImage(id: "2", secret: "secret2", server: "server2", farm: 2, title: "titleService2")]
    }
}
