//
//  ViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q  on 12/14/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class BestSellersViewController: UIViewController {

    
    @IBOutlet weak var bestSellerCollectionView: UICollectionView!
    
    @IBOutlet weak var categoryPickerView: UIPickerView!
    
    let cellSpacing = UIScreen.main.bounds.size.width * 0.05
    var categories = [Category]() {
        didSet {
            self.categoryPickerView.reloadAllComponents()
        }
    }
    
    var category = "" {
        didSet {
            loadBestSellersFromOnline()
        }
    }
    var bestSellers = [BestSeller]() {
        didSet {
            self.bestSellerCollectionView.reloadData()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.categoryPickerView.delegate = self
        self.categoryPickerView.dataSource = self
        self.bestSellerCollectionView.dataSource = self 
        getCategoriesFromOnline()
   
    }
    
    
    func getCategoriesFromOnline() {
        let setCategories = {(onlineCategories: [Category]) in
            self.categories = onlineCategories
        }
        let printErrors = {(error: Error) in
            print(error)
        }
        CategoryAPIClient.manager.getCategories(completionHandler: setCategories, errorHandler: printErrors)

    }
    func loadBestSellersFromOnline() {
        let setBestSellers = {(onlineBestSellers: [BestSeller]) in
            self.bestSellers = onlineBestSellers
        }
        let printErrors = {(error: Error) in
            print(error)
        }
        BestSellerAPIClient.manager.getBestSellers(with: category, completionHandler: setBestSellers, errorHandler: printErrors)
    }

}
extension BestSellersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bestSellers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = bestSellerCollectionView.dequeueReusableCell(withReuseIdentifier: "bestSellerCell", for: indexPath) as! BestSellerCollectionViewCell
        let bestSeller = bestSellers[indexPath.row]
        cell.weeksLabel.text = bestSeller.bookDetails[0].title
        cell.summaryTextView.text = bestSeller.bookDetails[0].description
        return cell
    }
    
}

extension BestSellersViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row].displayName
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.category = categories[row].encodedListName
        
    }
    
}

extension BestSellersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numCells: CGFloat = 1
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



