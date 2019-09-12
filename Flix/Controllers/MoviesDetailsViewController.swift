//
//  MoviesDetailsViewController.swift
//  Flix
//
//  Copyright © 2019 Rajwinder Singh. All rights reserved.
//

import UIKit
import AlamofireImage

class MoviesDetailsViewController: UIViewController {
    
    @IBOutlet weak var backdropView: UIImageView!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    
    var movie: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = movie.title
        titleLabel.sizeToFit()
        
        synopsisLabel.text = movie.overview
        synopsisLabel.sizeToFit()
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterUrl = URL(string: baseUrl + movie.posterPath)
        
        posterView.af_setImage(withURL: posterUrl!)
        
        // Setting up the backdrop view
        let backdropUrl = URL(string: "https://image.tmdb.org/t/p/w780" + movie.backdropPath)
        
        backdropView.af_setImage(withURL: backdropUrl!)
    }
    
    @IBAction func onPosterTapped(_ sender: Any) {
        performSegue(withIdentifier: "showTrailer", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let trailerViewController = segue.destination as! movieTrailerViewController
        trailerViewController.movieId = movie.id
    }
    
}
