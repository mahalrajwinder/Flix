//
//  HomeTableCell.swift
//  Flix
//
//  Copyright © 2019 Rajwinder Singh. All rights reserved.
//

import UIKit

class HomeTableCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}


extension HomeTableCell {
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forSection section: Int, cellWidth width: CGFloat, cellHeight height: CGFloat, sidePadding padding: CGFloat, interItemSpace space: CGFloat) {
        
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = section
        
        collectionView.backgroundColor = UIColor.darkGray
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = space
        layout.minimumInteritemSpacing = space
        layout.itemSize = CGSize(width: width, height: height)
                
        // Stops collection view if it was scrolling.
        collectionView.setContentOffset(collectionView.contentOffset, animated:false)
        
        collectionView.reloadData()
    }
}
