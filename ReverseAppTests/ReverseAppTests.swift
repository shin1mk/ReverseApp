//
//  ReverseAppTests
//
//  Created by SHIN MIKHAIL on 11.06.2023.
//

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
