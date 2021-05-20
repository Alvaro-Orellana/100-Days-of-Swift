//
//  ViewController.swift
//  Project 7
//
//  Created by Alvaro Orellana on 19-05-21.
//

import UIKit

class ViewController: UITableViewController {

    var petitions: [Petition] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "White House petitions"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        loadPetitions()
    }

    
    private func loadPetitions() {
        var url: URL!
        if tabBarController?.tabBarItem.tag == 0 {
            url = URL(string: "https://www.hackingwithswift.com/samples/petitions-1.json")!
        } else if tabBarController?.tabBarItem.tag == 1 {
            url = URL(string: "https://www.hackingwithswift.com/samples/petitions-2.json")!
        }

        if let jsonData = try? Data(contentsOf: url) {
            // Safe to parse
            parseJson(from: jsonData)
        }
    }
    
    
    private func parseJson(from data: Data)  {
        let decoder = JSONDecoder()
        if let petitions = try? decoder.decode(Petitions.self, from: data) {
            self.petitions = petitions.results
            tableView.reloadData()
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        let petition = petitions[indexPath.row]
        
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(60)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPetition = petitions[indexPath.row]
        let detailVC = DetailViewController()
        detailVC.selectedPetition = selectedPetition
        
        navigationController?.pushViewController(detailVC, animated: true)
    }

}

