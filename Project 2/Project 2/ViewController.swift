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
        
        askQuestion()
    }

    private func setUpButtons() {
        button1.layer.borderWidth = 2
        button2.layer.borderWidth = 2
        button3.layer.borderWidth = 2
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    
    func askQuestion() {
        questionsAsked += 1
        countries.shuffle()
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        correctAnswer = Int.random(in: 0...2)
        title = countries[correctAnswer].uppercased() + " \(score)"
        
    }
    
    
    @IBAction func flagTouched(_ sender: UIButton) {
        
        if sender.tag == correctAnswer {
            score += 1
        } else {
            scoreLabel.text = "Wrong!"
        }
        askQuestion()
    }
    
    
    private func finishGame() {
        let alert = UIAlertController(title: "The end", message: "You answered \(numberOfQuestionsPerGame) the game is finished", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true) {
            self.resetGame()
        }
    }
    
    private func resetGame() {
        score = 0
        questionsAsked = 0
        askQuestion()
    }
    
}

