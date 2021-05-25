//
//  ViewController.swift
//  Project 8
//
//  Created by Alvaro Orellana on 22-05-21.
//

import UIKit

class ViewController: UIViewController {
    
    private var scoreLabel: UILabel!
    private var cluesLabel: UILabel!
    private var answersLabel: UILabel!
    private var currentAnswer: UITextField!
    
    private let fontSize: CGFloat = 30
    
    private var letterButtons: [UIButton] = []
  
    // The cointainer view's height for the letter buttons
    private let buttonsViewHeight = 320
    
    // The container view's width for the letter buttons
    private let buttonsViewWidth = 750
   
    private let numberOfButtonRows = 4
    private let numberOfButtonColumns = 5
   
    private var buttonHeight: Int {
       buttonsViewHeight / numberOfButtonRows
    }
    private var buttonWidth: Int {
        buttonsViewWidth / numberOfButtonColumns
    }
    
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        scoreLabel.font = .systemFont(ofSize: fontSize)
        scoreLabel.backgroundColor = .red
        view.addSubview(scoreLabel)
        
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.textAlignment = .left
        cluesLabel.text = "Here will be the clues"
        cluesLabel.font = .systemFont(ofSize: fontSize)
        cluesLabel.numberOfLines = 0
        cluesLabel.backgroundColor = .blue
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(cluesLabel)
        
        answersLabel = UILabel()
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.textAlignment = .right
        answersLabel.text = "Here will be the answers"
        answersLabel.font = .systemFont(ofSize: fontSize)
        answersLabel.numberOfLines = 0
        answersLabel.backgroundColor = .green
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(answersLabel)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.textAlignment = .center
        currentAnswer.placeholder = "Tap letter to guess"
        currentAnswer.font = .systemFont(ofSize: fontSize)
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        let submitButton = UIButton(type: .system)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.setTitle("SUBMIT", for: .normal)
        view.addSubview(submitButton)
        
        let cancelButton = UIButton(type: .system)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitle("CANCEL", for: .normal)
        view.addSubview(cancelButton)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.backgroundColor = .yellow
        view.addSubview(buttonsView)
        
        
        NSLayoutConstraint.activate(
            [
                scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
                scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
                
                cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
                cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
                cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
                
                answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
                answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
                answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
                answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
                
                currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
                currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor,constant: 20),
                
                submitButton.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
                submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
                submitButton.heightAnchor.constraint(equalToConstant: 44),
                
                cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
                cancelButton.centerYAnchor.constraint(equalTo: submitButton.centerYAnchor),
                cancelButton.heightAnchor.constraint(equalTo: submitButton.heightAnchor),
                
                buttonsView.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 20),
                buttonsView.heightAnchor.constraint(equalToConstant: CGFloat(buttonsViewHeight)),
                buttonsView.widthAnchor.constraint(equalToConstant: CGFloat(buttonsViewWidth)),
                buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant:  -20)
            ]
        )
        
        
        // Creates all the numberButtons
        for row in 0..<numberOfButtonRows {
            for column in 0..<numberOfButtonColumns {
               
                let button = UIButton(type: .system)
                button.frame = CGRect(x: column * buttonWidth, y: row * buttonHeight, width: buttonWidth, height: buttonHeight)
                button.titleLabel?.font = .systemFont(ofSize: fontSize)
                button.setTitle("WWW", for: .normal)
                
                buttonsView.addSubview(button)
                letterButtons.append(button)
            }
        }
        
    }
    
    
    
}

