//
//  Petitions.swift
//  Project 7
//
//  Created by Alvaro Orellana on 19-05-21.
//

import Foundation

struct Petitions: Codable {
    let results: [Petition]
}


struct Petition: Codable {
    let title: String
    let body: String
    let signatureCount: Int
}
