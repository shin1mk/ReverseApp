////
////  ReverseAppTests
////
////  Created by SHIN MIKHAIL on 11.06.2023.
////
//
//import XCTest
//@testable import ReverseApp
//
//class MainControllerTests: XCTestCase {
//
//    var mainController: MainController!
//
//    override func setUp() {
//        super.setUp()
//        mainController = MainController()
//        _ = mainController.view
//    }
//    // Checking the stats are changing correctly
//    func testReverseButtonTapped_emptyState() throws {
//        mainController.reverseButton.sendActions(for: .touchUpInside)
//        XCTAssertEqual(mainController.appState, .empty)
//    }
//
//    func testReverseButtonTapped_inputState() throws {
//        mainController.appState = .input(text: "Hello World")
//        mainController.reverseButton.sendActions(for: .touchUpInside)
//        XCTAssertEqual(mainController.appState, .reversed(result: "olleH dlroW"))
//        XCTAssertEqual(mainController.resultLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines), "olleH dlroW")
//    }
//
//    func testReverseButtonTapped_reversedState() throws {
//        mainController.appState = .reversed(result: "dlroW olleH")
//        mainController.reverseButton.sendActions(for: .touchUpInside)
//        XCTAssertEqual(mainController.appState, .empty)
//    }
//}

import XCTest
@testable import ReverseApp

class ReverseManagerTests: XCTestCase {
    var reverseManager: ReverseManager!
    
    override func setUp() {
        super.setUp()
        reverseManager = ReverseManager()
    }
    
    override func tearDown() {
        reverseManager = nil
        super.tearDown()
    }
    
    func testReverseText() {
        let inputText = "Hello World"
        let expectedOutput = "olleH dlroW"
        let reversedText = reverseManager.reverseText(inputText)
        XCTAssertEqual(reversedText, expectedOutput)
    }
    
    func testReverseTextIgnoring() {
        let inputText = "Hello World"
        let ignoreText = "World"
        let expectedOutput = "olleH World"
        let reversedText = reverseManager.reverseTextIgnoring(inputText, ignoring: ignoreText)
        XCTAssertEqual(reversedText, expectedOutput)
    }
}
