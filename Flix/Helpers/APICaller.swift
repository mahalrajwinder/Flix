//
//  APICaller.swift
//  Flix
//
//  Copyright © 2019 Rajwinder Singh. All rights reserved.
//

import UIKit


struct APICaller
{
    static func getDataDictionary(url: URL, success: @escaping (NSDictionary) -> (), failure: @escaping (Error) -> ())
    {
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                failure(error)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
                success(dataDictionary)
            }
        }
        task.resume()
    }


    static func getMoviesArray(dataDictionary: NSDictionary) -> [Movie]
    {
        var movies = [] as! [Movie]
        let moviesJSON = dataDictionary["results"] as! [NSDictionary]
        
        for movie in moviesJSON
        {
            let movie = Movie(title: movie["title"] as! String,
                              overview: movie["overview"] as! String,
                              releaseDate: movie["release_date"] as! String,
                              posterPath: movie["poster_path"] as! String,
                              backdropPath: movie["backdrop_path"] as! String,
                              avgVotes: movie["vote_average"] as! Double,
                              id: movie["id"] as! Int)
            movies.append(movie)
        }
        
        return movies
    }
}
