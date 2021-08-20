//
//  Person.swift
//  Project 10
//
//  Created by Alvaro Orellana on 05-06-21.
//

import UIKit

class Person: NSObject, NSCoding {
  
    var name: String
    var imageId: String
    
    init(name: String, imagePath: String) {
        self.name = name
        self.imageId = imagePath
    }
    
    required init?(coder: NSCoder) {
        name = coder.decodeObject(forKey: "name") as? String ?? ""
        imageId = coder.decodeObject(forKey: "image") as? String ?? ""
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(imageId, forKey: "image")
    }
}
