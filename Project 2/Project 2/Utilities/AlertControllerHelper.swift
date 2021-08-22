//
//  AlertControllerHelper.swift
//  Project 2
//
//  Created by Alvaro Orellana on 21-08-21.
//

import Foundation
import UIKit

class AlertControllerHelper {
    static func present(title: String, message: String, controller: UIViewController) {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        
        alertVC.addAction(action)
        
        controller.present(alertVC, animated: true)
    }
}
