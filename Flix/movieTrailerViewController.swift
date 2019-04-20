//
//  movieTrailerViewController.swift
//  Flix
//
//  Created by Rajwinder on 4/19/19.
//  Copyright © 2019 Rajwinder. All rights reserved.
//

import UIKit
import WebKit

class movieTrailerViewController: UIViewController, WKUIDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    
    var movieId : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlPartOne = "https://api.themoviedb.org/3/movie/"
        let urlPartTwo = "/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: urlPartOne + String(movieId) + urlPartTwo)!
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                let movies = dataDictionary["results"] as! [[String:Any]]
                let movie = movies[0]
                let trailerKey = movie["key"] as! String
                let trailerUrl = URL(string: "https://www.youtube.com/watch?v=" + trailerKey)
                
                // Get movie trailer
                let trailerRequest = URLRequest(url: trailerUrl!)
                self.webView.load(trailerRequest)
            }
        }
        task.resume()
    }
    

    @IBAction func hideTrailer(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
