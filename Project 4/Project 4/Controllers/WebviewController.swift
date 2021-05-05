//
//  ViewController.swift
//  Project 4
//
//  Created by Alvaro Orellana on 03-05-21.
//

import UIKit
import WebKit

class WebviewController: UIViewController {

    var webView: WKWebView!
    var progressView: UIProgressView!
    var passedWebsite: String!
    var kvoToken: NSKeyValueObservation?

    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        setUpToolBar()
    }
    
    
    private func setUpToolBar() {
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
       
        let backItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(navigateBack))
        
        let fowardItem = UIBarButtonItem(image: UIImage(systemName: "arrow.forward"), style: .plain, target: self, action: #selector(navigateFoward))
        let progressItem =  UIBarButtonItem(customView: progressView)
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let reloadItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadPage))
        
        toolbarItems = [backItem, spaceItem, fowardItem, spaceItem, progressItem, spaceItem, reloadItem]
        navigationController?.isToolbarHidden = false
    }
    
     
    @objc private func reloadPage() {
        webView.reload()
    }
    
    
    @objc private func navigateBack() {
        webView.goBack()
    }
    
    @objc private func navigateFoward() {
        webView.goForward()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://" + passedWebsite)!

        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true

        // Oberserver that updates progress view
        kvoToken = webView.observe(\.estimatedProgress) { webView, _ in
            self.progressView.progress = Float(webView.estimatedProgress)
        }
        
    }
    
    
    private func websiteSelected(chosenAction: UIAlertAction) {
        let urlString = "https://" + chosenAction.title!
        let url = URL(string: urlString)!
        webView.load(URLRequest(url: url))
    }
    
    
    deinit {
        kvoToken?.invalidate()
    }


}



// MARK: - WKNavigationDelegate
extension WebviewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.url?.host
    }
    
    
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//
//        let url = navigationAction.request.url
//
//        if let host = url?.host {
//            for website in allowedWebsites {
//                if host.contains(website) {
//                    decisionHandler(.allow)
//                    return
//                }
//            }
//
//            // Alert controller indiciating blocked permission
//            alertDeniedPermission(for: host)
//        }
//
//        decisionHandler(.cancel)
//    }
    
    
    private func alertDeniedPermission(for host: String) {
        let alert = UIAlertController(title: "Can't navigato to website", message: "Denied permission to \(host). You can only navigate to preselected websites", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
    
}
