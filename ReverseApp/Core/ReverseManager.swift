//
//  ReverseManager.swift
//  Task1
//
//  Created by SHIN MIKHAIL on 10.06.2023.
//

import Foundation

class ReverseManager {
    func reverseText(_ text: String) -> String {
        let words = text.components(separatedBy: " ")
        let reversedWords = words.map { String($0.reversed()) }
        let reversedText = reversedWords.joined(separator: " ")
        return reversedText
    }
}

