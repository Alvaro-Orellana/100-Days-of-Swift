//
//  DetailViewController.swift
//  Fourth Challenge
//
//  Created by Alvaro Orellana on 03-09-21.
//

import UIKit

class DetailViewController: UIViewController {
    
    
    init(title: String ) {
        self.title = title
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
       // title = "Some title"
        view.backgroundColor = .red
    }
}
