//
//  AppState+Equatable.swift
//  ReverseApp
//
//  Created by SHIN MIKHAIL on 15.06.2023.
//

import Foundation
import UIKit

extension MainController.AppState: Equatable {
    static func ==(lhs: MainController.AppState, rhs: MainController.AppState) -> Bool {
        switch (lhs, rhs) {
        case (.empty, .empty):
            return true
        case let (.input(text1), .input(text2)):
            return text1 == text2
        case let (.reversed(result1), .reversed(result2)):
            return result1 == result2
        default:
            return false
        }
    }
}
