////
////  ReverseAppUITestsLaunchTests.swift
////  ReverseAppUITests
////
////  Created by SHIN MIKHAIL on 11.06.2023.
////
//
//import XCTest
//
//final class ReverseAppUITestsLaunchTests: XCTestCase {
//
//    override class var runsForEachTargetApplicationUIConfiguration: Bool {
//        true
//    }
//
//    override func setUpWithError() throws {
//        continueAfterFailure = false
//    }
//
//    func testLaunch() throws {
//        let app = XCUIApplication()
//        app.launch()
//        let attachment = XCTAttachment(screenshot: app.screenshot())
//        attachment.name = "Launch Screen"
//        attachment.lifetime = .keepAlways
//        add(attachment)
//    }
//}
