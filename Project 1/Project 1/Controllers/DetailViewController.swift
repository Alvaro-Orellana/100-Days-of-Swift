//
//  DetailViewController.swift
//  Project 1
//
//  Created by Alvaro Orellana on 27-04-21.
//

import UIKit

class DetailViewController: UIViewController {
    
    var vc: ViewController = ViewController()

    @IBOutlet weak var imageView: UIImageView!
    var imageName: String?
    var selectedPicturePosition: Int?
    var totalPictures: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Picture \(selectedPicturePosition!) of \(totalPictures!)"
        navigationItem.largeTitleDisplayMode = .never
        // Do any additional setup after loading the view.
        if let selectedImage = imageName {
            imageView.image = UIImage(named: selectedImage)
        }
        
        
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
