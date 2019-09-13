//
//  MoviesViewController.swift
//  Flix
//
//  Copyright © 2019 Rajwinder Singh. All rights reserved.
//

import UIKit
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var movies = [Movie]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let url = Url.nowPlaying.url(numPage: 1)
        APICaller.getDataDictionary(url: url, success: { (dataDictionary: NSDictionary) in
            self.movies = APICaller.getMoviesArray(dataDictionary: dataDictionary)
            self.tableView.reloadData()
        }, failure: { (Error) in
            print(Error.localizedDescription)
        })
        
        // Sets movie cell height based on device's screen width
        let heightRatio = UIScreen.main.bounds.width / 414
        tableView.rowHeight = 172 * heightRatio
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        let movie = movies[indexPath.row]
        cell.titleLabel.text = movie.title
        cell.synopsisLabel.text = movie.overview
        
        let posterUrl = URL(string: Url.basePosterUrl.rawValue + movie.posterPath)
        cell.posterView.af_setImage(withURL: posterUrl!)
        
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Find the selected movie
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let movie = movies[indexPath.row]
        
        // Pass the selected movie to the details view controller
        let detailsViewController = segue.destination as! MoviesDetailsViewController
        detailsViewController.movie = movie
        
        // De-selects the selected movie cell
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
