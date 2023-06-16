//
//  ReverseManager.swift
//  Task1
//
//  Created by SHIN MIKHAIL on 10.06.2023.
//

import Foundation

class ReverseManager {
    func reverseText(_ text: String) -> String {
        let words = text.components(separatedBy: .whitespaces)
        let reversedWords = words.map { String($0.reversed()) }
        return reversedWords.joined(separator: " ")
    }
    
    func reverseTextIgnoring(_ text: String, ignoring ignoreText: String) -> String {
        let words = text.components(separatedBy: .whitespaces)
        let reversedWords = words.map { word -> String in
            if word.lowercased() == ignoreText.lowercased() {
                return word
            } else {
                return String(word.reversed())
            }
        }
        return reversedWords.joined(separator: " ")
    }
}

