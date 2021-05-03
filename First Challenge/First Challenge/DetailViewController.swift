//
//  DetailViewController.swift
//  First Challenge
//
//  Created by Alvaro Orellana on 02-05-21.
//

import UIKit

class DetailViewController: UIViewController {

    var countryName: String?
    
    @IBOutlet weak var flagImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        flagImage.image = UIImage(named: countryName!)
        flagImage.layer.borderWidth = 2
        flagImage.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
    }
    

    @IBAction func shareButtonTouched(_ sender: UIButton) {
        let activityVC = UIActivityViewController(activityItems: [countryName, flagImage.image], applicationActivities: [])
        
        present(activityVC, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
