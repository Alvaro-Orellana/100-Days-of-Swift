//
//  ViewController.swift
//  Project 2
//
//  Created by Alvaro Orellana on 27-04-21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var countries = ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
    
    var score = 0 {
        didSet {
            
            nextQuestion()

            if score < 0 {
                score = 0
            }
            scoreLabel.text = "Score: \(score)"

            
        }
    }
    
    let numberOfQuestionsPerGame = 10
    var correctAnswer = 0
   
    var questionsAsked = 0 {
        didSet {
            if questionsAsked > numberOfQuestionsPerGame {
                finishGame()
            }

        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpButtons()
        nextQuestion()
    }

    private func setUpButtons() {
        button1.layer.borderWidth = 2
        button2.layer.borderWidth = 2
        button3.layer.borderWidth = 2
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    
    func nextQuestion(_ alertAction: UIAlertAction? = nil) {
        questionsAsked += 1
        countries.shuffle()
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        correctAnswer = Int.random(in: 0...2)
        title = countries[correctAnswer].uppercased()
    }
    
    
    @IBAction func shareButtonTouched(_ sender: UIBarButtonItem) {
        //presentAlertController("Score", message: "Current score: \(score)")
        AlertControllerHelper.present(title: "Score", message: "Current score \(score)", controller: self)
    }
    
    
    @IBAction func flagTouched(_ sender: UIButton) {
        
        let userChoice = sender.tag
        
        if userChoice == correctAnswer {
            score += 1
            
        } else {
            score -= 1
            //presentAlertController("Wrong", message: "That's the flag of \(countries[userChoice])")
            AlertControllerHelper.present(title: "Wrong", message: "That's the flag of \(countries[userChoice])", controller: self)
        }
    }
    
    
    
    private func presentAlertController(_ title: String, message: String) {
       
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(action)
        present(alert, animated: true)

    }
    
    
    
    private func finishGame() {
        
        let gameOverMessage = "You answered correctly \(score) out of \(numberOfQuestionsPerGame) questions "
        
        //presentAlertController("The end", message: gameOverMessage)
        AlertControllerHelper.present(title: "The end", message: gameOverMessage, controller: self)
        self.score = 0
        self.questionsAsked = 0
        
    }
    
    
}

