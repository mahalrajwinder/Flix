//
//  APICaller.swift
//  Flix
//
//  Copyright © 2019 Rajwinder Singh. All rights reserved.
//

import UIKit


func getDataDictionary(url: URL) -> [String: Any]
{
    var dataDictionary = [String: Any]()
    
    let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10.0)
    let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
    
    let task = session.dataTask(with: request) { (data, response, error) in
        // This will run when the network request returns
        if let error = error {
            print(error.localizedDescription)
        } else if let data = data {
            dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        }
    }
    task.resume()
    return dataDictionary
}


func getMoviesArray(url: URL) -> [Movie]
{
    var movies = [Movie]()
    let moviesJSON = getDataDictionary(url: url)["results"] as! [[String: Any]]
    
    for movie in moviesJSON
    {
        let movie = Movie(title: movie["title"] as! String,
                          overview: movie["overview"] as! String,
                          releaseDate: movie["release_date"] as! String,
                          posterPath: movie["poster_path"] as Any,
                          backdropPath: movie["backdrop_path"] as Any,
                          avgVotes: movie["vote_average"] as! Double,
                          id: movie["id"] as! Int)
        movies.append(movie)
    }
    return movies
}


func getLatestMovie() -> Movie
{
    let url = URL(string: Url.baseUrl.rawValue + "latest?api_key=" + Url.APIKey.rawValue)!
    let movieData = getDataDictionary(url: url)
    
    return Movie(title: movieData["title"] as! String,
                 overview: movieData["overview"] as! String,
                 releaseDate: movieData["release_date"] as! String,
                 posterPath: movieData["poster_path"] as Any,
                 backdropPath: movieData["backdrop_path"] as Any,
                 avgVotes: movieData["vote_average"] as! Double,
                 id: movieData["id"] as! Int)
}


func getDailyTrending(numPage: Int) -> [Movie]
{
    let page = "&page=" + String(numPage)
    let url = URL(string: "https://api.themoviedb.org/3/trending/movie/day?api_key=" + Url.APIKey.rawValue + page)!
    
    return getMoviesArray(url: url)
}


func getNowPlaying(numPage: Int) -> [Movie]
{
    let page = "&page=" + String(numPage)
    let url = URL(string: Url.baseUrl.rawValue + "now_playing?api_key=" + Url.APIKey.rawValue + page)!
    
    return getMoviesArray(url: url)
}


func getUpcoming(numPage: Int) -> [Movie]
{
    let page = "&page=" + String(numPage)
    let url = URL(string: Url.baseUrl.rawValue + "upcoming?api_key=" + Url.APIKey.rawValue + page)!
    
    return getMoviesArray(url: url)
}


func getPopular(numPage: Int) -> [Movie]
{
    let page = "&page=" + String(numPage)
    let url = URL(string: Url.baseUrl.rawValue + "popular?api_key=" + Url.APIKey.rawValue + page)!
    
    return getMoviesArray(url: url)
}


func getTopRated(numPage: Int) -> [Movie]
{
    let page = "&page=" + String(numPage)
    let url = URL(string: Url.baseUrl.rawValue + "top_rated?api_key=" + Url.APIKey.rawValue + page)!
    
    return getMoviesArray(url: url)
}


func getSimilarMovies(numPage: Int, movieID: Int) -> [Movie]
{
    let page = "&page=" + String(numPage)
    let url = URL(string: Url.baseUrl.rawValue + String(movieID) + "/similar?api_key=" + Url.APIKey.rawValue + page)!
    
    return getMoviesArray(url: url)
}
