//
//  TextManager.swift
//  Project 5
//
//  Created by Alvaro Orellana on 11-05-21.
//

import UIKit

struct TextManager {
    
    let minimunWordLenght = 3
    var errorTitle: String?
    var errorMessage: String?
    
    mutating func isWordValid(_ word: String, withTitle title: String, usedWords: [String]) -> Bool {
        
        let isPossible = isPosible(word, with: title)
        let isOriginal = isOriginal(word, usedWords: usedWords)
        let isReal = isReal(word)
        
        if isPossible && isOriginal && isReal && word.count >= minimunWordLenght && word != title {
            return true
       
        } else {
            
            if !isPossible {
                errorTitle = "Word not possible"
                errorMessage = "You can't spell that word from \(title)"
            
            } else if !isReal {
                errorTitle = "Non existent word"
                errorMessage = "You can't just make words up"
            
            } else if !isOriginal {
                errorTitle = "Used word"
                errorMessage = "You already used that word. Check the list"
            
            } else if word.count < minimunWordLenght {
                errorTitle = "Too short"
                errorMessage = "Words have to be at least \(minimunWordLenght) characters long"
            
            } else if word == title {
                errorTitle = "Copy of given word"
                errorMessage = "Can't just copy the same word yo"
            
            }
            
            
            return false
        }
        
    }
    
    
    func getErrorMessageAndTitle() -> (String?, String?) {
        return (errorTitle, errorMessage)
    }
    
    
    private func isReal(_ word: String) -> Bool {
        let checker = UITextChecker()
        let wordRange = NSRange(location: 0, length: word.utf8.count)
        
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: wordRange, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    
    private func isOriginal(_ word: String, usedWords: [String]) -> Bool {
        return !usedWords.contains(word)
    }
    
    
    private func isPosible(_ word: String, with title: String) -> Bool {
        
        var titleToCheck = title
        
        for letter in word {
          
            if let index = titleToCheck.firstIndex(of: letter) {
                titleToCheck.remove(at: index)
            } else {
                return false
            }
        }
        
        return true
    }
    
}
