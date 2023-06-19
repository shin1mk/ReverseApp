//
//  ReverseAppUITests.swift
//  ReverseAppUITests
//
//  Created by SHIN MIKHAIL on 11.06.2023.
//

import XCTest

class MainControllerUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testReverseButtonTapped() throws {
        let inputTextField = app.textFields["Text to reverse"]
        let reverseButton = app.buttons["ReverseButton"]
            
        inputTextField.tap()
        inputTextField.typeText("Reverse")
        XCTAssertTrue(reverseButton.isEnabled)
            
        reverseButton.tap()
        XCTAssertEqual(reverseButton.label, "Reverse")
        _ = app.staticTexts.element(matching: .any, identifier: "resultLabel")
        XCTAssertTrue(!(inputTextField.value as? String ?? "").isEmpty)

        reverseButton.tap()
        XCTAssertEqual(reverseButton.label, "Clear")
        
        reverseButton.tap()
    }
}
