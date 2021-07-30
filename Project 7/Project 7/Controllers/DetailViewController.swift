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
    var searchWord: String?
    
    // TODO: - Consider pasing
//    init(selectedPetition: Petition?, searchWord: String?) {
//        self.selectedPetition = selectedPetition
//        self.searchWord = searchWord
//    }
    
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
      
        
        // Do any additional setup after loading the view.
        guard let selectedPetition = selectedPetition else { return }
        
        let petitionDate = Date(timeIntervalSince1970: TimeInterval(selectedPetition.created))
        let htmlString =
            """
                <html>
                    <head>
                        <meta name="viewport" content="width=device-width, initial-scale=1">
                        <style> body { font-size: 150%; } </style>
                    </head>
            
                    <body>
            
                        <h3>\(selectedPetition.title)</h3>
                        <h5> \(petitionDate.getFormattedDate()) </h5>
                        <h5> Number of votes: \(selectedPetition.signatureCount) </h5>
                        \(selectedPetition.body)
                        <h1> </h1>
                    </body>
                </html>
            """
        webView.loadHTMLString(htmlString, baseURL: nil)
    }
    
    
}


extension Date {
    func getFormattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }
}
