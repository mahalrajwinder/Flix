//
//  MovieGridViewController.swift
//  Flix
//
//  Copyright © 2019 Rajwinder Singh. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieGridViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var movies = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layoutSizes = getLayoutSizes()

        collectionView.backgroundColor = UIColor.init(red: 34/255.0, green: 34/255.0, blue: 34/255.0, alpha: 1)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: layoutSizes.sidePadding, bottom: 0, right: layoutSizes.sidePadding)
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.minimumLineSpacing = layoutSizes.interItemSpace
        layout.minimumInteritemSpacing = layoutSizes.interItemSpace
        layout.itemSize = CGSize(width: layoutSizes.cellWidth, height: layoutSizes.cellHeight)
        
        let url = Url.nowPlaying.url(numPage: 1)
        APICaller.getDataDictionary(url: url, success: { (dataDictionary: NSDictionary) in
            self.movies = APICaller.getMoviesArray(dataDictionary: dataDictionary)
            self.collectionView.reloadData()
        }, failure: { (Error) in
            print(Error.localizedDescription)
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as! MovieGridCell
        
        let movie = movies[indexPath.item]
        let posterUrl = URL(string: Url.basePosterUrl.rawValue + movie.posterPath)
        
        cell.posterView.af_setImage(withURL: posterUrl!)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Find the selected movie
        let cell = sender as! UICollectionViewCell
        let indexPath = collectionView.indexPath(for: cell)!
        let movie = movies[indexPath.item]
        
        // Pass the selected movie to the details view controller
        let detailsViewController = segue.destination as! MoviesDetailsViewController
        detailsViewController.movie = movie
    }
    
    
    func getLayoutSizes() -> LayoutSizes
    {
        let heightToWidthRatio : CGFloat = 278 / 185.0
        
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            var width = (collectionView.frame.size.width - 76) / 3
            if width > 185 {
                width = CGFloat(185)
            }
            let height = heightToWidthRatio * width
            
            return LayoutSizes(sidePadding: 20, interItemSpace: 12, cellWidth: width, cellHeight: height, headerHeight: 36, headerTopPadding: 12)
        }
        else
        {
            var width = (collectionView.frame.size.width - 44) / 3
            if width > 185 {
                width = CGFloat(185)
            }
            let height = heightToWidthRatio * width
            
            return LayoutSizes(sidePadding: 10, interItemSpace: 8, cellWidth: width, cellHeight: height, headerHeight: 26, headerTopPadding: 3)
        }
    }
}
