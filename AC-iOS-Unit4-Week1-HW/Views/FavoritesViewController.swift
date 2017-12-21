//
//  FavoritesViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/16/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {

    
    @IBOutlet weak var favoritesCollectionView: UICollectionView!
    
     let cellSpacing = UIScreen.main.bounds.size.width * 0.05
    
    var image: UIImage!
    var favorites = [Favorite]() {
        didSet {
            self.favoritesCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PersistenceManager.manager.load()
        self.favorites = PersistenceManager.manager.getFavorites()
        self.favoritesCollectionView.dataSource = self
        self.favoritesCollectionView.delegate = self


    }
    override func viewWillAppear(_ animated: Bool) {
        PersistenceManager.manager.load()
        self.favorites = PersistenceManager.manager.getFavorites()
        self.favoritesCollectionView.reloadData()
    }

}
extension FavoritesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let favoriteBook = favorites[indexPath.row]
        let cell = favoritesCollectionView.dequeueReusableCell(withReuseIdentifier: "favoriteCell", for: indexPath) as! FavoritesCollectionViewCell
        if let image = favoriteBook.image {
            cell.favoriteImageView.image = image
        }
        return cell
        
    }
    
    
    
}

extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numCells: CGFloat = 3
        let numSpaces: CGFloat = numCells + 1
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        return CGSize(width: (screenWidth - (cellSpacing * numSpaces)) / numCells, height: screenHeight * 0.25)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: cellSpacing, left: cellSpacing, bottom: 0, right: cellSpacing)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
}
}





