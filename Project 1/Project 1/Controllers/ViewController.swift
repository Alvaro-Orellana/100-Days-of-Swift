//
//  ViewController.swift
//  Project 1
//
//  Created by Alvaro Orellana on 26-04-21.
//

import UIKit

class ViewController: UITableViewController {
    
    var picturesNames = [String]()
    
    let userDefaultKey = "key"
    
    var imageVisitsCount: [Int] = []

    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        loadPicturesNames()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = false
        tableView.reloadData()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = true
        saveToUserDefaults()
    }
    
    
    // MARK: - IB Actions
    @IBAction func shareButtonPressed(_ sender: UIBarButtonItem) {
        let messageToShare = "This is the message to share my app"
        
        let activityVC = UIActivityViewController(activityItems: [messageToShare], applicationActivities: [])
        present(activityVC, animated: true)
    }
    
    
    
    // MARK: - Loading and Saving
    private func loadPicturesNames() {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            let fm = FileManager.default
            let path = Bundle.main.resourcePath!
            let resources = try! fm.contentsOfDirectory(atPath: path)

            for resource in resources {
                if resource.hasPrefix("nssl") {
                    // this is a picture to load!
                    self?.picturesNames.append(resource)
                }
            }
            
            self?.picturesNames.sort()
            self?.loadImageCount()
        }
    }


    private func loadImageCount() {
        let defaults = UserDefaults.standard
        
        if let imageCount = defaults.object(forKey: userDefaultKey) as? [Int] {
            imageVisitsCount =  imageCount
            
        } else {
            imageVisitsCount = Array(repeating: 0, count: picturesNames.count)
        }
    }
    
    
    private func saveToUserDefaults() {
        let defaults = UserDefaults.standard
        defaults.set(imageVisitsCount, forKey: userDefaultKey)
    }
    
}


// MARK: - TableView data source and delegate methods
extension ViewController {
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return picturesNames.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        cell.textLabel?.text = picturesNames[indexPath.row]
        
        let imageVisitCount = imageVisitsCount[indexPath.row]
        cell.detailTextLabel?.text = "Image shown \(imageVisitCount) times"
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailVC = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            
            // Configure the view contorller
            let imageName = picturesNames[indexPath.row]
            let selectedPicturePosition = indexPath.row + 1
            let totalPictures = picturesNames.count
            
            detailVC.configure(imageName, selectedPicturePosition, totalPictures)
            imageVisitsCount[indexPath.row] += 1
            
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
}
