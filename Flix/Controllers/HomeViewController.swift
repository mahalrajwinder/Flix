//
//  HomeViewController.swift
//  Flix
//
//  Copyright © 2019 Rajwinder Singh. All rights reserved.
//

import UIKit
import AlamofireImage

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var layoutSizes: LayoutSizes!
    let categoryURL = [Url.nowPlaying.url(numPage: 1), Url.upcoming.url(numPage: 1)]
    var movies = [[Movie]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        layoutSizes = getLayoutSizes()
        
        var remainingURLs = categoryURL.count
        
        for url in categoryURL
        {
            remainingURLs -= 1
            
            APICaller.getDataDictionary(url: url, success: { (dataDictionary: NSDictionary) in
                self.movies.append(APICaller.getMoviesArray(dataDictionary: dataDictionary))
                
                if remainingURLs == 0
                {
                    self.tableView.reloadData()
                }
            }, failure: { (Error) in
                print(Error.localizedDescription)
            })
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return layoutSizes.headerHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let frame: CGRect = tableView.frame
        
        let label = UILabel(frame: CGRect(x: layoutSizes.sidePadding, y: layoutSizes.headerTopPadding, width: frame.size.width / 2, height: 12))
        label.text = "Section Title \(section)"
        label.textColor = UIColor.white
        label.numberOfLines = 1
        label.font = UIFont(name:"verdana-Bold", size: 16.0)
        label.sizeToFit()
        
        let button = UIButton(frame: CGRect(x: frame.size.width - 55 - layoutSizes.sidePadding, y: layoutSizes.headerTopPadding, width: 55, height: 21))
        button.setTitle("See All", for: .normal)
        button.titleLabel?.font = UIFont(name:"verdana-Bold", size: 12.0)
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 36))
        headerView.backgroundColor = UIColor.darkGray
        headerView.addSubview(label)
        headerView.addSubview(button)
        
        return headerView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return layoutSizes.cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableCell") as! HomeTableCell
        cell.backgroundColor = UIColor.darkGray
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell

    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let homeCell = cell as? HomeTableCell else { return }
        
        homeCell.setCollectionViewDataSourceDelegate(self, forSection: indexPath.section, cellWidth: layoutSizes.cellWidth, cellHeight: layoutSizes.cellHeight, sidePadding: layoutSizes.sidePadding, interItemSpace: layoutSizes.interItemSpace)
    }
    
    
    func getLayoutSizes() -> LayoutSizes
    {
        let heightToWidthRatio : CGFloat = 278 / 185.0
        
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            var width = (tableView.frame.size.width - 64) / 3
            if width > 185 {
                width = CGFloat(185)
            }
            let height = heightToWidthRatio * width
            
            return LayoutSizes(sidePadding: 20, interItemSpace: 8, cellWidth: width, cellHeight: height, headerHeight: 46, headerTopPadding: 25)
        }
        else
        {
            var width = (tableView.frame.size.width - 32) / 3
            if width > 185 {
                width = CGFloat(185)
            }
            let height = heightToWidthRatio * width
            
            return LayoutSizes(sidePadding: 10, interItemSpace: 4, cellWidth: width, cellHeight: height, headerHeight: 36, headerTopPadding: 15)
        }
    }

}


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeGridCell", for: indexPath) as! HomeGridCell
        
        let movie = movies[collectionView.tag][indexPath.item]
        let posterUrl = URL(string: Url.basePosterUrl.rawValue + movie.posterPath)
        cell.posterView.af_setImage(withURL: posterUrl!)
        
        return cell
    }
    
    
    // MARK: - Navigation
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let movie = movies[collectionView.tag][indexPath.item]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailsVC = storyboard.instantiateViewController(withIdentifier: "DetailVC") as! MoviesDetailsViewController
        
        detailsVC.movie = movie
        
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
}
