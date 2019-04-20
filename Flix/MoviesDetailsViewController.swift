//
//  MoviesDetailsViewController.swift
//  Flix
//
//  Created by Rajwinder on 4/19/19.
//  Copyright © 2019 Rajwinder. All rights reserved.
//

import UIKit
import AlamofireImage

class MoviesDetailsViewController: UIViewController {
    
    @IBOutlet weak var backdropView: UIImageView!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    
    var movie: [String:Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = movie["title"] as? String
        titleLabel.sizeToFit()
        
        synopsisLabel.text = movie["overview"] as? String
        synopsisLabel.sizeToFit()
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        
        posterView.af_setImage(withURL: posterUrl!)
        
        // Setting up the backdrop view
        let backdropPath = movie["backdrop_path"] as! String
        let backdropUrl = URL(string: "https://image.tmdb.org/t/p/w780" + backdropPath)
        
        backdropView.af_setImage(withURL: backdropUrl!)
        
        // Adding tap action to poster
        let tap = UITapGestureRecognizer(target: self, action: #selector(MoviesDetailsViewController.posterTapped))
        posterView.addGestureRecognizer(tap)
        posterView.isUserInteractionEnabled = true
    }
    
    @objc func posterTapped()
    {
        performSegue(withIdentifier: "showTrailer", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let trailerViewController = segue.destination as! movieTrailerViewController
        trailerViewController.movieId = movie["id"] as? Int
    }
    
}
