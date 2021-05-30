//
//  ViewController.swift
//  Project 7
//
//  Created by Alvaro Orellana on 19-05-21.
//

import UIKit

class PetitionsViewController: UITableViewController {
    
    // MARK: - Instance properties
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var lookUpBarButton: UIBarButtonItem!
    private let rowHeight = 60

    
    // This is to store and keep all the petitions without filtering,
    // so the table view's array can be reverted back to all results
    private(set) var allPetitions: [Petition] = []
    
    // The array for the data source. Could be the same as all petitions if is unfiltered
    private(set) var filteredPetitions: [Petition] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private(set) var isShowingFilteredPetitions = false {
        didSet {
            if isShowingFilteredPetitions {
                doneBarButton.isEnabled = true
                lookUpBarButton.isEnabled = false
                
            } else {
                doneBarButton.isEnabled = false
                lookUpBarButton.isEnabled = true
            }
        }
    }
    
    var isMostRecentPetitionsViewController: Bool {
        navigationController?.tabBarItem.tag == 0
    }
    
    var isTopRatedPetitionsViewController: Bool {
        // Setted in SceneDelegate
        navigationController?.tabBarItem.tag == 1

    }
    
    
    // MARK: - Instance methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "White House Petitions"
        navigationController?.navigationBar.prefersLargeTitles = true
        doneBarButton.isEnabled = false
        
        guard let dataSourceURL = getURL() else {
            fatalError("PetitionsViewController doesn't have a designated tag for it's tabBarItem. Can't determine if belongs to the Most Recent tab, or the Top Rated tab, or another. Must have a tabBarItem with an associated tag to know which url to use")
        }
        
        loadPetitions(from: dataSourceURL)
    }
    
    
    // TODO: Rename function to a better intention of the code
    private func getURL() -> URL? {
        // Depending on which PetitionsViewController self is (Most Recent or Top Rated)
        // give a different url to be it's data source
        
        if isMostRecentPetitionsViewController {
            return URL(string: "https://www.hackingwithswift.com/samples/petitions-1.json")!
            
        } else if isTopRatedPetitionsViewController {
            return URL(string: "https://www.hackingwithswift.com/samples/petitions-2.json")!
        
        } else {
            // In the future here could be other cases if more tabs want to be added,
            // as long as that the functionality desired is the same and only url for
            // the data souce changes
            return nil
        }
    }
    
    
    private func loadPetitions(from url: URL) {
        
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            
            guard let self = self else {return}
            
            if let jsonData = try? Data(contentsOf: url) {
                // Downloaded data without problems
                
                do {
                    // Parse, sort and store petitions
                    let unsortedPetitions = try self.parseJson(from: jsonData)
                    self.allPetitions = self.sortPetitions(unsortedPetitions)
                    self.filteredPetitions = self.allPetitions
             
                } catch {
                    print("An error ocurred. PetitionsViewController/loadPetitions: \(error)")
                    // TODO: Improve error message.
                    self.showAlert(title: "Could't decode data", message: "Failed to decode petitions. This is a programmers error, probably cause the json wasnt decoded properly, Error: \(error.localizedDescription)")
                }
                
            } else {
                self.showAlert(title: "Couldn't load data", message: "There was a problem loading the feed; please check your connection and try again.")
            }
        }
    }
    
    
    private func parseJson(from data: Data) throws -> [Petition]  {
        let decoder = JSONDecoder()
        
        do {
            let petitions = try decoder.decode(Petitions.self, from: data)
            return petitions.results
        } catch {
            throw error
        }
    }
    
    
    private func sortPetitions(_ petitions: [Petition] ) -> [Petition ] {
        
        var sortedPetitions: [Petition] = []
        
        if isMostRecentPetitionsViewController {
            // Sorty by most recent
            sortedPetitions = petitions.sorted(by: { $0.created > $1.created })
            
        } else if isTopRatedPetitionsViewController {
            // Sort by top rated
            sortedPetitions = petitions.sorted(by: { $0.signatureCount > $1.signatureCount })
            
        } else {
            // If no tabBarItem's tag matches just return the petitions unsorted
            sortedPetitions = petitions
        }
        
        return sortedPetitions
    }
    
    
    private func showAlert(title: String, message: String) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
      
    }
    
    
    @IBAction func barButtonPressed(_ sender: UIBarButtonItem) {
        // Show only results that match with string entered by the user
        
        let alert = UIAlertController(title: "Filter results", message: "Look for petitions matching your search", preferredStyle: .alert)
        alert.addTextField {$0.placeholder = "Type here"}
        
        let doneAction = UIAlertAction(title: "Done", style: .default) { _ in
            
            // Get user input and filter petitions with it when action is pressed
            if let userInput = alert.textFields?[0].text {
                // Filter array
                self.filterPetitions(containing: userInput)
            }
        }
        
        alert.addAction(doneAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        
        present(alert, animated: true)
    }
    
    
    private func filterPetitions(containing word: String) {
        // Returns array of petitions matching word written  by user
        filteredPetitions = allPetitions.filter { petition in
            // Ignores capitalization of selected word
            let upperCased = word.uppercased()
            
            return petition.title.uppercased().contains(upperCased) || petition.body.uppercased().contains(upperCased)
        }
        isShowingFilteredPetitions = true
    }
    
    
    @IBAction func doneBarButtonPressed(_ sender: UIBarButtonItem) {
        // Unfilters the petitons and shows all of them
        filteredPetitions = allPetitions
        isShowingFilteredPetitions = false
    }
    
}



// MARK: - Methods for table view controller data source and delegate
extension PetitionsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        let petition = filteredPetitions[indexPath.row]
        
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(rowHeight)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRow = filteredPetitions[indexPath.row]
        let detailVC = DetailViewController()
        detailVC.selectedPetition = selectedRow
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
