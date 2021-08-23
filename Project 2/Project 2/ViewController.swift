//
//  ViewController.swift
//  Project 2
//
//  Created by Alvaro Orellana on 27-04-21.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    
    
    // MARK: - Varibles
    var countries = ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
    var correctAnswer = 0
    let numberOfQuestionsPerGame = 7
    private let maxScoreKey = "maxScoreKey"
    
    var score = 0 {
        didSet {
            if score < 0 {
                score = 0
            }
            scoreLabel.text = "Score: \(score)"
        }
    }

   
    var questionsAsked = 0 {
        didSet {
            if questionsAsked > numberOfQuestionsPerGame {
                finishGame()
            }

        }
    }
    
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
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
        AlertControllerHelper.present(title: "Score", message: "Current score \(score)", controller: self)
    }
    
    
    @IBAction func flagTouched(_ sender: UIButton) {
        let userChoice = sender.tag
        
        if userChoice == correctAnswer {
            score += 1
            nextQuestion()
            
        } else {
            score -= 1
            nextQuestion()
            AlertControllerHelper.present(title: "Wrong", message: "That's the flag of \(countries[userChoice])", controller: self)
        }
    }
    
    
    private func finishGame() {
       
        
        
        let maxScore = getMaxScore()
        if score > maxScore {
            setMaxScore(score)
            AlertControllerHelper.present(title: "New max score!", message: "Congratulations your score: \(score) surpassed the previous max score: \(maxScore)", controller: self)
        }
        
        let gameOverMessage = "You answered correctly \(score) out of \(numberOfQuestionsPerGame) questions "
        AlertControllerHelper.present(title: "The end", message: gameOverMessage, controller: self)
        
        self.score = 0
        self.questionsAsked = 0
        
    }
    
    private func getMaxScore() -> Int {
        let defaults = UserDefaults.standard
        return defaults.integer(forKey: maxScoreKey)
     
    }
    
    
    private func setMaxScore(_ maxScore: Int) {
        let defaults = UserDefaults.standard
        defaults.set(maxScore, forKey: maxScoreKey)
        print("A new score has been saved it value is \(maxScore)")
    }
    
    
}

