//
//  TableTableViewController.swift
//  Project 4
//
//  Created by Alvaro Orellana on 05-05-21.
//

import UIKit

class TableTableViewController: UITableViewController {
    
    
    let allowedWebsites = ["google.com", "apple.com", "hackingwithswift.com", "amazon.com", "tesla.com"]
    
    var selectedWebsite: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
//
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allowedWebsites.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)

        cell.textLabel?.text = allowedWebsites[indexPath.row]
        return cell
    }
    



    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedWebsite = allowedWebsites[indexPath.row]
        performSegue(withIdentifier: "segue_TableVC_To_Webview", sender: self)
    }
    
 
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Pass the selected object to the new view controller.
        if segue.identifier == "segue_TableVC_To_Webview" {
            if let webviewController = segue.destination as? WebviewController {
                webviewController.passedWebsite = selectedWebsite
            }
        }
     
    }
    

}
