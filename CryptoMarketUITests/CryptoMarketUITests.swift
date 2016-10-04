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
		
		
		let app = XCUIApplication()
		app.tables.staticTexts["Bitcoin <-> 1CRedit"].tap()
		app.otherElements.containing(.navigationBar, identifier:"Bitcoin <-> 1CRedit").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 2).children(matching: .other).element(boundBy: 1).staticTexts["Month"].tap()
		
		snapshot("Detail View")
		
		app.navigationBars["Bitcoin <-> 1CRedit"].buttons["CryptoMarket"].tap()
		
		sleep(2)
		
		snapshot("Rates View")
		
	}
		
}
