//
//  movieTrailerViewController.swift
//  Flix
//
//  Copyright © 2019 Rajwinder Singh. All rights reserved.
//

import UIKit
import WebKit

class movieTrailerViewController: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    
    var movieId : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add webview
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: CGRect(x: 0, y: 88, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height - 88)), configuration: webConfiguration)
        webView.allowsBackForwardNavigationGestures = true
        webView.uiDelegate = self
        view.addSubview(webView)
        
        let url = Url.video(movieID: movieId)
        
        APICaller.getDataDictionary(url: url, success: { (dataDictionary: NSDictionary) in
            let trailerURL = APICaller.getYouTubeTrailerUrl(dataDictionary: dataDictionary)
            let trailerRequest = URLRequest(url: trailerURL)
            self.webView.load(trailerRequest)
        }, failure: { (Error) in
            print(Error.localizedDescription)
        })
    }
    

    @IBAction func hideTrailer(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
