//
//  UIFont+CustomFonts.swift
//  Task1
//
//  Created by SHIN MIKHAIL on 25.05.2023.
//

import Foundation
import UIKit

extension UIFont {
    static func customFontRegular(ofSize size: CGFloat) -> UIFont? {
        return UIFont(name: "Roboto-Regular", size: size)
    }
    static func customFontBold(ofSize size: CGFloat) -> UIFont? {
        return UIFont(name: "Roboto-Bold", size: size)
    }
}
