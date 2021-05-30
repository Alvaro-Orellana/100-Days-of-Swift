//
//  FileLoadingError.swift
//  Project 8
//
//  Created by Alvaro Orellana on 29-05-21.
//

import Foundation

enum FileLoadingError: Error {
    case NoSuchFileExists(message: String)
}
