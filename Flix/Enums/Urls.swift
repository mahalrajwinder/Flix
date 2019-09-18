//
//  Urls.swift
//  Flix
//
//  Copyright © 2019 Rajwinder Singh. All rights reserved.
//

import Foundation


enum Url: String {
    case baseURL = "https://api.themoviedb.org/3/"
    case basePosterUrl = "https://image.tmdb.org/t/p/w185"
    case baseBackdropUrl = "https://image.tmdb.org/t/p/w780"
    case APIKey = "?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"
    
    case upcoming, popular
    case nowPlaying = "now_playing"
    case topRated = "top_rated"
    case dailyTrending = "trending/movie/day"
    
    
    func url(numPage: Int) -> URL {
        let urlPath = Url.APIKey.rawValue + "&page=" + String(numPage)
        
        if self.rawValue == Url.dailyTrending.rawValue {
            return URL(string: Url.baseURL.rawValue + self.rawValue + urlPath)!
        } else {
            return URL(string: Url.baseURL.rawValue + "movie/" + self.rawValue + urlPath)!
        }
    }
    
    
    static func latest() -> URL {
        return URL(string: Url.baseURL.rawValue + "movie/latest" + Url.APIKey.rawValue)!
    }
    
    
    static func video(movieID: Int) -> URL {
        return URL(string: Url.baseURL.rawValue + "movie/" + String(movieID) + "/videos" + Url.APIKey.rawValue)!
    }
    
    
    static func similar(numPage: Int, movieID: Int) -> URL {
        let urlPath = Url.APIKey.rawValue + "&page=" + String(numPage)
        
        return URL(string: Url.baseURL.rawValue + "movie/" + String(movieID) + "/similar" + urlPath)!
    }
}
