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
    
    
    let myRefreshControl = UIRefreshControl()
    var movieCategory: String!
    var categoryFunc: ((Int) -> URL)!
    var movies = [Movie]()
    var page = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        self.title = movieCategory
        
        myRefreshControl.addTarget(self, action: #selector(loadMovies), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
        
        let heightRatio = UIScreen.main.bounds.width / 414.0
        var height = 217.0 * heightRatio
        if height > 278 {
            height = CGFloat(278)
        }
        tableView.rowHeight = height
    }
    
    
    // MARK: - Functions for requesting data.
    
    @objc func loadMovies() {
        page = 1
        let url = categoryFunc(page)
        
        // Request the data and reload the table view.
        APICaller.getDataDictionary(url: url, success: { (dataDictionary: NSDictionary) in
            self.movies = APICaller.getMoviesArray(dataDictionary: dataDictionary)
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
            }, failure: { (Error) in
            print(Error.localizedDescription)
            })
    }
    
    func loadMoreMovies() {
        page += 1
        let url = categoryFunc(page)
        
        // Request the data and reload the table view.
        APICaller.getDataDictionary(url: url, success: { (dataDictionary: NSDictionary) in
            let movies = APICaller.getMoviesArray(dataDictionary: dataDictionary)
            self.movies.append(contentsOf: movies)
            self.tableView.reloadData()
        }, failure: { (Error) in
            print(Error.localizedDescription)
        })
    }
    
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    // This function enables the infinite scroll.
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 2 == movies.count {
            loadMoreMovies()
        }
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
    
    
    // MARK: - Navigation
    
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
