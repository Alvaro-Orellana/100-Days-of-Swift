//
//  ViewController.swift
//  Second Challenge
//
//  Created by Alvaro Orellana on 18-05-21.
//

import UIKit

class ViewController: UITableViewController {
    
    private(set) var shoppingList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Shopping List"
        createAndAddToolBarItems()
    }
    
    
    private func createAndAddToolBarItems() {
        navigationController?.isToolbarHidden = false
        
        let trashItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteItemsButtonPressed))
        let spaceBarItem = UIBarButtonItem(systemItem: .flexibleSpace)
        let shareButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonPressed))
        
        toolbarItems = [trashItem, spaceBarItem, shareButtonItem]
    }
    
    
    @objc private func shareButtonPressed() {
        let shoppingListAsOneString = shoppingList.joined(separator: "\n")
        
        let activityController = UIActivityViewController(activityItems: [shoppingListAsOneString], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }
    
    
    @IBAction func newItemButtonPressed(_ sender: UIBarButtonItem) {
        createAndPresentAlertController()
    }
    
    @objc func deleteItemsButtonPressed() {
        let alert = UIAlertController(title: "Delete all items", message: "Are you sure you want to delete everything in the list?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        let confirmAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.shoppingList.removeAll()
            self.tableView.reloadData()
            
        }
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }
    
    
    
    private func createAndPresentAlertController() {
        let alert = UIAlertController(title: "New shopping Item", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        let confirmAction = UIAlertAction(title: "Done", style: .default) { _ in
            if let shoppingItem = alert.textFields?[0].text {
                // Get input text from user and append it to array
                
                self.shoppingList.insert(shoppingItem, at: 0)
                let indexPath = IndexPath(row: 0, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
            }
        }
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }
    
    
    
    // MARK: - Table view data source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }
    
    
    // Swipe left to delete row
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            shoppingList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
    }
    
}

