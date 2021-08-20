//
//  Person.swift
//  Project 10
//
//  Created by Alvaro Orellana on 05-06-21.
//

import UIKit

class Person: NSObject, Codable {

    var name: String
    var imageId: String
    
    init(name: String, imagePath: String) {
        self.name = name
        self.imageId = imagePath
    }
}
