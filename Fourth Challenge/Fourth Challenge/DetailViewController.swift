//
//  DetailViewController.swift
//  Fourth Challenge
//
//  Created by Alvaro Orellana on 03-09-21.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var imageFileName: String!
    
    func setUp(title: String, imageFileName: String) {
        self.title = title
        //imageView.image = UIImage(named: imageFileName)
        self.imageFileName = imageFileName
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .red
        let photoPath = getDocumentsDirectory().appendingPathComponent(imageFileName).path
        imageView.image = UIImage(contentsOfFile: photoPath)
        
    }
    
  
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}
