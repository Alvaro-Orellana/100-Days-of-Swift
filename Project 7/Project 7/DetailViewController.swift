//
//  DetailViewController.swift
//  Project 7
//
//  Created by Alvaro Orellana on 19-05-21.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    var selectedPetition: Petition?
    var webView: WKWebView!
    
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let selectedPetition = selectedPetition else { return }

        let htmlString =
            """
                <html>
                    <head>
                        <meta name="viewport" content="width=device-width, initial-scale=1">
                        <style> body { font-size: 150%; } </style>
                    </head>
            
                    <body>
                        \(selectedPetition.body)
                    </body>
                </html>
            """
        webView.loadHTMLString(htmlString, baseURL: nil)
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
