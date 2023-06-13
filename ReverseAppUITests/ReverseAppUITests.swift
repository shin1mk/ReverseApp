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
        // Tap on the input field and enter text
        inputTextField.tap()
        inputTextField.typeText("Reverse")
        // Verify that the button is enabled
        XCTAssertTrue(reverseButton.isEnabled)
        // Tap the button
        reverseButton.tap()
        // Check that the button title has changed
        XCTAssertEqual(reverseButton.label, "Reverse")
        // Find the result label after tapping the button
        _ = app.staticTexts["resultLabel"]
        // Verify that the input field is still full
        XCTAssertTrue(!(inputTextField.value as? String ?? "").isEmpty)
        // Tap the button
        reverseButton.tap()
        // Check that the button title has changed back to "Clear"
        XCTAssertEqual(reverseButton.label, "Clear")
        reverseButton.tap()
        // Check that the result label is empty
        XCTAssertEqual(inputTextField.label, "")
    }
}
