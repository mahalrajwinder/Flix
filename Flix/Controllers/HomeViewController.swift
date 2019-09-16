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
    
    let categories = [("Trending Now", Url.dailyTrending.url), ("Top Movies", Url.topRated.url), ("Popular", Url.popular.url), ("Upcoming", Url.upcoming.url)]
    var layoutSizes: LayoutSizes!
    var movies = [[Movie]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        layoutSizes = getLayoutSizes()
        
        var remainingCategories = categories.count
        
        for (_, f) in categories
        {
            remainingCategories -= 1
            
            APICaller.getDataDictionary(url: f(1), success: { (dataDictionary: NSDictionary) in
                self.movies.append(APICaller.getMoviesArray(dataDictionary: dataDictionary))
                
                if remainingCategories == 0
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
        label.text = categories[section].0
        label.textColor = UIColor.white
        label.numberOfLines = 1
        label.font = UIFont(name:"verdana-Bold", size: 16.0)
        label.sizeToFit()
        
        let button = UIButton(frame: CGRect(x: frame.size.width - 55 - layoutSizes.sidePadding, y: layoutSizes.headerTopPadding, width: 55, height: 21))
        button.setTitle("See All", for: .normal)
        button.titleLabel?.font = UIFont(name:"verdana-Bold", size: 12.0)
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: layoutSizes.headerHeight))
        headerView.backgroundColor = UIColor.init(red: 34/255.0, green: 34/255.0, blue: 34/255.0, alpha: 1)
        headerView.addSubview(label)
        headerView.addSubview(button)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return layoutSizes.sidePadding
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: layoutSizes.sidePadding))
        footerView.backgroundColor = UIColor.init(red: 34/255.0, green: 34/255.0, blue: 34/255.0, alpha: 1)
        
        return footerView
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
        cell.backgroundColor = UIColor.init(red: 34/255.0, green: 34/255.0, blue: 34/255.0, alpha: 1)
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
            var width = (tableView.frame.size.width - 76) / 3
            if width > 185 {
                width = CGFloat(185)
            }
            let height = heightToWidthRatio * width
            
            return LayoutSizes(sidePadding: 20, interItemSpace: 12, cellWidth: width, cellHeight: height, headerHeight: 36, headerTopPadding: 12)
        }
        else
        {
            var width = (tableView.frame.size.width - 44) / 3
            if width > 185 {
                width = CGFloat(185)
            }
            let height = heightToWidthRatio * width
            
            return LayoutSizes(sidePadding: 10, interItemSpace: 8, cellWidth: width, cellHeight: height, headerHeight: 26, headerTopPadding: 3)
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
