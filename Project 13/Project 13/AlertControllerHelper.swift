//
//  AlertControllerHelper.swift
//  Project 13
//
//  Created by Alvaro Orellana on 13-09-21.
//

import UIKit

class AlertControllerHelper {
    static func presentAlert(title: String , message: String, presenter: UIViewController) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default))
        presenter.present(alertController, animated: true)
        
    }
}
