//
//  ViewController.swift
//  First Challenge
//
//  Created by Alvaro Orellana on 02-05-21.
//

import UIKit

class ViewController: UITableViewController {
    
    var flagsNames = [String]()
    var selectedFlag: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadFiles()
    }

    
    private func loadFiles() {
        let fm = FileManager.default
        let resources = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: resources)

        flagsNames = items.filter { $0.hasSuffix(".png") }
    }
    
    
    

}


extension ViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFlag = flagsNames[indexPath.row]
       performSegue(withIdentifier: "segueToDetailController", sender: self)

    }
    
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let detailVC = segue.destination as? DetailViewController {
            detailVC.countryName = selectedFlag
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flagsNames.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell =  tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        cell.textLabel?.text = flagsNames[indexPath.row]
        cell.imageView?.image = UIImage(named: flagsNames[indexPath.row])
        return cell
    }
    
    
    
}



