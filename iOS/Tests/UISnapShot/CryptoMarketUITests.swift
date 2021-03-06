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
        
        snapshot("0_List-View", timeWaitingForIdle: 5)
        
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["Bitcoin"]/*[[".cells.staticTexts[\"Bitcoin\"]",".staticTexts[\"Bitcoin\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        snapshot("1_Detail-View", timeWaitingForIdle: 5)
        
        app.navigationBars["Bitcoin"].buttons["Cryptocurrencies"].tap()
        
        let tabBarsQuery = app.tabBars
        tabBarsQuery.children(matching: .button).element(boundBy: 1).tap()
        collectionViewsQuery.children(matching: .cell).element(boundBy: 0).otherElements.children(matching: .button)
            .element.tap()
        
        snapshot("2_Add-Item", timeWaitingForIdle: 2)
        
        let elementsQuery = app.scrollViews.otherElements
        let symbolTextField = elementsQuery.textFields["Symbol"]
        symbolTextField.tap()
        symbolTextField.typeText("BTC")
        
        let amountTextField = elementsQuery.textFields["Amount"]
        amountTextField.tap()
        amountTextField.typeText("1.0")
        elementsQuery.buttons["Add"].tap()
        
        snapshot("3_Portfolio", timeWaitingForIdle: 2)
		
	}
		
}
