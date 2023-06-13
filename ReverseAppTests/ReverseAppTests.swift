//
//  ReverseAppTests
//
//  Created by SHIN MIKHAIL on 11.06.2023.
//

import XCTest
@testable import ReverseApp

class MainControllerTests: XCTestCase {
    
    var mainController: MainController!
    
    override func setUp() {
        super.setUp()
        mainController = MainController()
        _ = mainController.view
    }
    
    override func tearDown() {
        mainController = nil
        super.tearDown()
    }
    
    func testInputState() {
        mainController.appState = .input(text: "Hello")
        XCTAssertEqual(mainController.reverseButton.currentTitle, "Reverse")
        XCTAssertTrue(mainController.reverseButton.isEnabled)
    }
    
    func testReversedState() {
        mainController.appState = .reversed(result: "olleH")
        XCTAssertEqual(mainController.reverseButton.currentTitle, "Clear")
        XCTAssertEqual(mainController.resultLabel.text, "olleH")
    }
    // Checking the stats are changing correctly
    func testReverseButtonTapped_emptyState() throws {
        mainController.reverseButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(mainController.appState, .empty)
    }
    
    func testReverseButtonTapped_inputState() throws {
        mainController.appState = .input(text: "Hello World")
        mainController.reverseButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(mainController.appState, .reversed(result: "olleH dlroW"))
        XCTAssertEqual(mainController.resultLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines), "olleH dlroW")
    }
    
    func testReverseButtonTapped_reversedState() throws {
        mainController.appState = .reversed(result: "dlroW olleH")
        mainController.reverseButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(mainController.appState, .empty)
    }
    // updated code for testing the correct copying of the result to the clipboard
    func testCopyResultLabel() {
        let resultText = "Reversed Text"
        mainController.resultLabel.text = resultText
        let pasteboard = UIPasteboard.general
        mainController.copyResultLabel()
        XCTAssertEqual(pasteboard.string, resultText)
    }
    
}
