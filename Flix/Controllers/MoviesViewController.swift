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
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
                let moviesJSON = dataDictionary["results"] as! [[String: Any]]
                
                for movie in moviesJSON
                {
                    let movie = Movie(title: movie["title"] as! String,
                                      overview: movie["overview"] as! String,
                                      releaseDate: movie["release_date"] as! String,
                                      posterPath: movie["poster_path"] as! String,
                                      backdropPath: movie["backdrop_path"] as! String,
                                      avgVotes: movie["vote_average"] as! Double,
                                      id: movie["id"] as! Int)
                    self.movies.append(movie)
                }
                self.tableView.reloadData()
            }
        }
        task.resume()
        
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
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie.posterPath
        let posterUrl = URL(string: baseUrl + posterPath)
        
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
