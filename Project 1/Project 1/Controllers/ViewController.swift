//
//  ViewController.swift
//  Project 1
//
//  Created by Alvaro Orellana on 26-04-21.
//

import UIKit

class ViewController: UITableViewController {
    
    var picturesNames = [String]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadPicturesNames()
        
        title = "mi app ☠️😺"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    
    private func loadPicturesNames() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let resources = try! fm.contentsOfDirectory(atPath: path)

        for resource in resources {
            if resource.hasPrefix("nssl") {
                // this is a picture to load!
                picturesNames.append(resource)
            }
        }
        picturesNames.sort()
        print(picturesNames)
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return picturesNames.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        cell.textLabel?.text = picturesNames[indexPath.row]
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailVC = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            
            // Set up the view contorller
            detailVC.imageName = picturesNames[indexPath.row]
            detailVC.selectedPicturePosition = indexPath.row + 1
            detailVC.totalPictures = picturesNames.count
            
            navigationController?.pushViewController(detailVC, animated: true)
        }

    }

}

