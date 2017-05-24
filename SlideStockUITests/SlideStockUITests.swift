//
//  SlideStockUITests.swift
//  SlideStockUITests
//
//  Created by AtsuyaSato on 2017/05/24.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import XCTest

class SlideStockUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let app = XCUIApplication()
        
        // MARK: - Main
        snapshot("Main")

        // Translate to importViewController
        XCUIApplication().navigationBars["Slide Stock"].buttons["icon import"].tap()
        
        // MARK: - Import
        snapshot("Import")
        // Input Slide URL
        let inputSlideUrlHereTextField = app.textFields["Input slide url here"]
        inputSlideUrlHereTextField.tap()
        inputSlideUrlHereTextField.typeText("natmark/asoviva-lt")
        app.buttons["Return"].tap()
        
        // Import Slide
        app.buttons["btn import"].tap()
        
        // Search Slide
        let tablesQuery = app.tables
        tablesQuery.searchFields["Search"].tap()
        app.searchFields["Search"].typeText("aso")
        tablesQuery.staticTexts["Asoviva-LT"].tap()
        
        // MARK: - Viewer
        snapshot("Viewer")
        // Show Slide PDF
        let element = app.webViews.children(matching: .other).element
        element.children(matching: .other).element(boundBy: 1).swipeUp()
        // Return to Main View
        app.navigationBars["Asoviva-LT"].children(matching: .button).matching(identifier: "Back").element(boundBy: 0).tap()
        app.buttons["Cancel"].tap()
    }
}
