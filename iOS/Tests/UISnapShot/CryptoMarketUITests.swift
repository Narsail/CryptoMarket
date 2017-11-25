//
//  CryptoMarketUITests.swift
//  CryptoMarketUITests
//
//  Created by David Moeller on 04/10/2016.
//  Copyright © 2016 David Moeller. All rights reserved.
//

import XCTest

class CryptoMarketUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
		
		let app = XCUIApplication()
        setupSnapshot(app)
		app.launch()

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
	func testTakeScreenshots() {
        
        snapshot("List View", timeWaitingForIdle: 5)
		
	}
		
}
