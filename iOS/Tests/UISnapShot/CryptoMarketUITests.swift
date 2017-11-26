//
//  CryptoMarketUITests.swift
//  CryptoMarketUITests
//
//  Created by David Moeller on 04/10/2016.
//  Copyright © 2016 David Moeller. All rights reserved.
//

import XCTest

class CryptoMarketUITests: XCTestCase {
    
    let app = XCUIApplication()
        
    override func setUp() {
        super.setUp()
		
        setupSnapshot(app)
		app.launch()

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
	func testTakeScreenshots() {
        
        snapshot("List View", timeWaitingForIdle: 5)
        
        app.collectionViews/*@START_MENU_TOKEN@*/.staticTexts["Bitcoin"]/*[[".cells.staticTexts[\"Bitcoin\"]",".staticTexts[\"Bitcoin\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        snapshot("Detail View", timeWaitingForIdle: 5)
		
	}
		
}
