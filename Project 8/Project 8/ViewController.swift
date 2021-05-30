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
    private var characterCountLabel: UILabel!
    
    private let fontSize: CGFloat = 30
    
    private var letterButtons: [UIButton] = []
    private var selectedButtons: [UIButton] = []

    
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
    
   
    private(set) var score = 0 {
        didSet {
            if score < 0 {
                score = 0
            }
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    private(set) var solutions = [String]()
    private(set) var currentLevel = 1
    
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        scoreLabel.font = .systemFont(ofSize: fontSize)
        view.addSubview(scoreLabel)
        
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.textAlignment = .left
        cluesLabel.text = ""
        cluesLabel.font = .systemFont(ofSize: fontSize)
        cluesLabel.numberOfLines = 0
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(cluesLabel)
        
        answersLabel = UILabel()
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.textAlignment = .right
        answersLabel.text = "Here will be the answers"
        answersLabel.font = .systemFont(ofSize: fontSize)
        answersLabel.numberOfLines = 0
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(answersLabel)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.textAlignment = .center
        currentAnswer.placeholder = "Tap letter to guess"
        currentAnswer.font = .systemFont(ofSize: fontSize)
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        
        characterCountLabel = UILabel()
        characterCountLabel.translatesAutoresizingMaskIntoConstraints = false
        characterCountLabel.text = "0 Letters"
        characterCountLabel.font = .systemFont(ofSize: 25)
        view.addSubview(characterCountLabel)
        
        let submitButton = UIButton(type: .system)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.setTitle("SUBMIT", for: .normal)
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        view.addSubview(submitButton)
        
        let cancelButton = UIButton(type: .system)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitle("CANCEL", for: .normal)
        cancelButton.addTarget(self, action: #selector(clearCurrentStatus), for: .touchUpInside)
        view.addSubview(cancelButton)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.layer.borderWidth = 1
        buttonsView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        view.addSubview(buttonsView)
        
        let viewMargin = view.layoutMarginsGuide
        
        NSLayoutConstraint.activate(
            [
                scoreLabel.topAnchor.constraint(equalTo: viewMargin.topAnchor),
                scoreLabel.trailingAnchor.constraint(equalTo: viewMargin.trailingAnchor),
                
                cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
                cluesLabel.leadingAnchor.constraint(equalTo: viewMargin.leadingAnchor, constant: 100),
                cluesLabel.widthAnchor.constraint(equalTo: viewMargin.widthAnchor, multiplier: 0.6, constant: -100),
                
                answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
                answersLabel.trailingAnchor.constraint(equalTo: viewMargin.trailingAnchor, constant: -100),
                answersLabel.widthAnchor.constraint(equalTo: viewMargin.widthAnchor, multiplier: 0.4, constant: -100),
                answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
                
                currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor,constant: 20),
                currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
                
                characterCountLabel.topAnchor.constraint(equalTo: currentAnswer.topAnchor),
                characterCountLabel.leadingAnchor.constraint(equalTo: currentAnswer.trailingAnchor),
                
                submitButton.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
                submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
                submitButton.heightAnchor.constraint(equalToConstant: 44),
                
                cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
                cancelButton.centerYAnchor.constraint(equalTo: submitButton.centerYAnchor),
                cancelButton.heightAnchor.constraint(equalTo: submitButton.heightAnchor),
                
                buttonsView.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 20),
                buttonsView.bottomAnchor.constraint(equalTo: viewMargin.bottomAnchor, constant:  -20),
                buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                buttonsView.heightAnchor.constraint(equalToConstant: CGFloat(buttonsViewHeight)),
                buttonsView.widthAnchor.constraint(equalToConstant: CGFloat(buttonsViewWidth)),
               
            ]
        )
        
        
        // Creates all the numberButtons
        for row in 0..<numberOfButtonRows {
            for column in 0..<numberOfButtonColumns {
                
                let button = UIButton(type: .system)
                button.frame = CGRect(x: column * buttonWidth, y: row * buttonHeight, width: buttonWidth, height: buttonHeight)
                button.titleLabel?.font = .systemFont(ofSize: fontSize)
                button.setTitle("WWW", for: .normal)
                button.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                
                buttonsView.addSubview(button)
                letterButtons.append(button)
            }
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLevel { answersText, cluesText, subWords in
            self.updateLabelsAndButtonsText(with: (answersText, cluesText, subWords))
        }
    }
    
    
    private func loadLevel(completionHandler: @escaping (String, String, [String]) -> Void) {
        // Reset corresponding variables before loading a level
        resetGameStatus()
        
        var cluesText = ""
        var answersText = ""
        var subWords = [String]()
        
        DispatchQueue.global(qos: .userInteractive).async { [self] in
            
            do {
                var lines = try loadFile(with: currentLevel).components(separatedBy: "\n")
                lines.shuffle()
                
                // Parses each line
                for (index, line) in lines.enumerated() {
                    let (solutionWord, clue, answer) = parseLine(line)
                    
                    solutions.append(solutionWord)

                    answersText += "\(solutionWord.count) Letters \n"
                    cluesText += "\(index + 1) \(clue)\n"
                    subWords += answer.components(separatedBy: "|")
                }
                
                completionHandler(answersText, cluesText, subWords)
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
    // Resets everything except the score
    private func resetGameStatus() {
        for button in letterButtons {
            button.isHidden = false
        }
        selectedButtons.removeAll(keepingCapacity: true)
        solutions.removeAll(keepingCapacity: true)
    }
    
    
    private func loadFile(with currentLevel: Int) throws -> String {
        let fileName = "level\(currentLevel)"
        if let levelsFileURL = Bundle.main.path(forResource: fileName, ofType: "txt") {
            if let levelContents = try? String(contentsOfFile: levelsFileURL) {
                return levelContents
            }
        }
        
        throw FileLoadingError.NoSuchFileExists(message: "There's no such file named: \(fileName)")
    }
    
    
    private func parseLine(_ line: String) -> (String, String, String) {
        let parts = line.components(separatedBy: ":")
        let answer = parts[0]
        let clue = parts[1]
        
        let solutionWord = answer.replacingOccurrences(of: "|", with: "")
        
        return (solutionWord, clue, answer)
    }
    
    
    
    private func updateLabelsAndButtonsText(with results: (answersText: String, cluesText: String, subWords: [String]) ) {
        DispatchQueue.main.async { [weak self] in
            self?.answersLabel.text = results.answersText
            self?.cluesLabel.text = results.cluesText
            self?.updateButtonTitles(with: results.subWords)
        }
    }
    
    
    private func updateButtonTitles(with buttonsSubWords: [String]) {
        guard letterButtons.count == buttonsSubWords.count else {
            fatalError("Argument passed to this function should have the same number of items a letter buttons")
        }
        
        let shuffledWords = buttonsSubWords.shuffled()
        
        for index in letterButtons.indices {
            letterButtons[index].setTitle(shuffledWords[index], for: .normal)
        }
    }
    
    
    @objc private func letterTapped(_ sender: UIButton) {
        sender.isEnabled = false
        selectedButtons.append(sender)
        currentAnswer.text! += sender.currentTitle!
        characterCountLabel.text = "\(currentAnswer.text!.count) Letters"
    }

    
    // Main method for the game's core logic
    @objc private func submitButtonTapped(_ sender: UIButton) {
        guard let submitedAsnwer = currentAnswer.text else { return }
        
        if isAnswerCorrect(answer: submitedAsnwer) {
            hideSelectedButtons()
            updateAnswersAndCluesLabels(with: submitedAsnwer)
            score += 1
            
            if isGameFinished() {
                levelUp()
            }
        } else {
            let alert = UIAlertController(title: "Wrong answer", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            present(alert, animated: true)
            score -= 1
        }
        
        clearCurrentStatus()
    }
    
    
    private func isAnswerCorrect(answer: String) -> Bool {
        //TODO: Potential bug here. It should check the specific word for equality instead of just "contains"
        solutions.contains(answer)
    }
    

    private func hideSelectedButtons() {
        for button in selectedButtons {
            button.isHidden = true
        }
    }
    
    
    // Should only be called when the submitted answer is correct
    private func updateAnswersAndCluesLabels(with submitedAnswer: String) {
        
        // TODO: Should make a check that solutions words never repeat.
        if let correctAnswerIndex = solutions.firstIndex(of: submitedAnswer) {
            
            // Separate the text from both labels into arrays
            var splittedClues = cluesLabel.text!.components(separatedBy: "\n")
            var splitedAnswers = answersLabel.text!.components(separatedBy: "\n")
            
            // Update the corresponding element
            splittedClues[correctAnswerIndex] += " ✅"
            splitedAnswers[correctAnswerIndex] = submitedAnswer
            
            // Join into a single string and asign to label's text
            cluesLabel.text = splittedClues.joined(separator: "\n")
            answersLabel.text = splitedAnswers.joined(separator: "\n")
        
        } else {
            print("Submited answer: \(submitedAnswer) was not part of correct answers. Correct answers: \(solutions)")
        }
      
    }
    
    
    private func isGameFinished() -> Bool {
        // If all buttons are hidden game is finished
        return letterButtons.filter { !$0.isHidden }.count == 0
    }
    
    private func levelUp() {
        currentLevel += 1
        newLevelAlert()
    }
    
    
    private func newLevelAlert() {
        let alert = UIAlertController(title: "Level Finished", message: "Congratulations you answered correctly all the words in this level", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "LET'S GOOOO", style: .default) { _ in
            self.loadLevel { answersText, cluesText, subWords in
                self.updateLabelsAndButtonsText(with: (answersText, cluesText, subWords))
            }
        })
        
        present(alert, animated: true)
    }
    
    
    @objc private func clearCurrentStatus(_ sender: UIButton? = nil) {
        currentAnswer.text = ""
        characterCountLabel.text = "\(currentAnswer.text!.count) Letters"
        selectedButtons.removeAll()
        for button in letterButtons {
            button.isEnabled = true
        }
    }
 
    
}

