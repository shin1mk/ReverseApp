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
}
