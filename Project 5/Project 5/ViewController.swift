//
//  ViewController.swift
//  Project 5
//
//  Created by Alvaro Orellana on 10-05-21.
//

import UIKit

class ViewController: UITableViewController {
    
    // MARK: - Variables
    var textManager = TextManager()
    var allWords = [String]()
    var usedWords = [String]()
    
    let titleKeyUserDefaults = "title key"
    let usedWordsKeyUserDefaults = "used word key "
  
   
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationItem()
        loadWords()
        //newGame()
        loadProgress()
    }
 
    override func viewWillDisappear(_ animated: Bool) {
        saveProgress()
    }

    
    
    // MARK: - Methods
    private func setUpNavigationItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(newGame))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(barButtonTouched))
    }
    
    
    private func loadWords() {
        // Look for file path
        if let path = Bundle.main.path(forResource: "start", ofType: "txt") {
            
            // Convert file into a string
            if let wordsFromFile = try? String(contentsOfFile: path) {
                
                // Convert string into array using a new line as separator
                allWords = wordsFromFile.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
            // Executes if file couldn't be loaded or stored in array
            allWords = ["no funciono"]
        }
    }

    
    @objc private func barButtonTouched() {
        // Creates and presentes alert controller
        let alert = UIAlertController(title: "Enter word", message: nil, preferredStyle: .alert)
        
        alert.addTextField()
        
        let submitAction = UIAlertAction(title: "Ok", style: .default) { [weak self, weak alert] _ in
            // Get user typed word from textfield
            guard let typedWord = alert?.textFields?[0].text else { return }
            
            // Adds user typed word to the array
            self?.submit(typedWord)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
    
        alert.addAction(submitAction)
        alert.addAction(cancelAction)
       
        self.present(alert, animated: true)
    }
    
    
    private func submit(_ answer: String) {
        
        let userAnswer = answer.lowercased()
        let title = title?.lowercased()
        
        let isWordValid = textManager.isWordValid(userAnswer, withTitle: title!, usedWords: usedWords)
        
        if  isWordValid {
            usedWords.insert(answer, at: 0)
            
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
        
        }  else {
            
            let (errorTitle, errorMessage) = textManager.getErrorMessageAndTitle()
            let alert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            present(alert, animated: true)
        }
    }
    
    
    @objc private func newGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    
    private func loadProgress() {
        let defaults = UserDefaults.standard
        
        title = defaults.string(forKey: titleKeyUserDefaults) ?? allWords.randomElement()
        
        if let savedWordsArray = defaults.array(forKey: usedWordsKeyUserDefaults) as? [String] {
            usedWords = savedWordsArray
        }
    }
    
    
    private func saveProgress() {
        let defaults = UserDefaults.standard
        defaults.set(title, forKey: titleKeyUserDefaults)
        defaults.set(usedWords, forKey: usedWordsKeyUserDefaults)
    }
}



// MARK: - Table View Controller methods
extension ViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "identifier", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        
        return cell
    }
    
}
