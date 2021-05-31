//
//  ViewController.swift
//  Third Challenge
//
//  Created by Alvaro Orellana on 30-05-21.
//

import UIKit

class ViewController: UIViewController {
    
    let guessWords = [
        "surprise",
        "knight",
        "talented"
    ]
    
    var currentWord = 0
    var chosenLetter = ""
    var lives = 7 {
        didSet {
            livesLabel.text = "Lives: \(lives)"
        }
    }
    var guessedLetters = [String]()

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var livesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        // Do any additional setup after loading the view.
        livesLabel.text = "Lives: \(lives)"
        textView.text = convertToUnderScores(word: guessWords[currentWord])
    }

    private func convertToUnderScores(word: String) -> String {
        var returnWord = ""
        for _ in word {
            returnWord += "_  "
        }
        return returnWord
    }
    
    

}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let userInput = textField.text else { return  false}
        
        if userInput.count > 1 {
            textField.placeholder = "Type one letter at a time"
            textField.text = ""
            return false
        } else {
            chosenLetter = userInput
            textField.resignFirstResponder()
            textField.placeholder = "Guess Word"
            textField.text = ""
            return true
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if guessWords[currentWord].contains(chosenLetter) {
            guessedLetters.append(chosenLetter)
            textView.text = addCorrectLetter()
            
            if isWordComplete() {
                newWord()
            }
            
        } else {
           lives -= 1
        }
    }
    
    
    private func addCorrectLetter() -> String {
        var text = ""
        for character in guessWords[currentWord] {
            if guessedLetters.contains(String(character)) {
                text += "\(character)  "
            } else {
                text += "_  "
            }
            
        }
        return text
        
    }
 
    
    private func isWordComplete() -> Bool {
        let checkWord = textView.text.replacingOccurrences(of: "  ", with: "")
        return checkWord == guessWords[currentWord]
    }
    
    private func newWord() {
        let alert = UIAlertController(title: "Success", message: "new word coming up", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default){  [self] _ in
            currentWord += 1
            textView.text = convertToUnderScores(word: guessWords[currentWord])
            livesLabel.text = "Lives: \(lives)"
        })
        present(alert, animated: true)
      
    }
    
    
}

