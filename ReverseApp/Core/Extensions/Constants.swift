//
//  Constants.swift
//  ReverseApp
//
//  Created by SHIN MIKHAIL on 16.06.2023.
//

import Foundation
import UIKit

extension MainController {
    enum Constants {
        static let topOffset = 100
        static let spacing = 16
        static let horizontalInset = 16
        enum InputTextField {
            static let topOffset = 40
            static let height = 40
        }
        enum InputDefaultCustom {
            static let topOffset = 10
            static let height = 30
        }
        enum Underline {
            static let topOffset = 10
            static let height = 1
        }
        enum ResultLabel {
            static let topOffset = 10
        }
        enum Segmented {
            static let topOffset = 13
            static let height = 30
        }
        enum ReverseButton {
            static let bottomOffset = -5
            static let horizontalInset = 13
            static let height = 66
        }
    }
    enum Colors {
        static let white = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        static let black = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        static let gray = UIColor(red: 60/255, green: 60/255, blue: 67/255, alpha: 1.0)
        static let lightGray = UIColor(red: 60/255, green: 60/255, blue: 67/255, alpha: 0.6)
        static let systemBlue = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0)
        static let lightSystemBlue = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 0.6)
    }
}
