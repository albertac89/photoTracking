//
//  MainViewTests.swift
//  photoTrackingUITests
//
//  Created by Albert Aige Cortasa on 25/4/23.
//

import XCTest

final class MainViewTests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func test_texts() throws {
        let title = app.staticTexts["Photo tracking"]
         
        XCTAssert(title.exists)
    }
}
