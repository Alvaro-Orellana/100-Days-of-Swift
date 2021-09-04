//
//  ViewController.swift
//  Fourth Challenge
//
//  Created by Alvaro Orellana on 03-09-21.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(didPressedCameraButton))
    }

    
    
    @objc func didPressedCameraButton() {
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "whazuuuuuup"
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let detailVC = DetailViewController(title: "The image selected was \(index)")
        //detailVC.title = "The image selected was \(index)"
       navigationController?.pushViewController(detailVC, animated: true)
       // performSegue(withIdentifier: "segue", sender: self)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        print("prepare for segue was calledx")
    }
    

}



