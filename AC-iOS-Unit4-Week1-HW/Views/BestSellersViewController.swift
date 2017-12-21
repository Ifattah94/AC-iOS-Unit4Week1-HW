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
        //loading data from online to populate Picker View
        CategoryAPIClient.manager.getCategories(completionHandler: setCategories, errorHandler: printErrors)

    }
    //get Best Seller Info from NY TImes API
    func loadBestSellersFromOnline() {
        let setBestSellers = {(onlineBestSellers: [BestSeller]) in
            self.bestSellers = onlineBestSellers
        }
        let printErrors = {(error: Error) in
            print(error)
        }
        BestSellerAPIClient.manager.getBestSellers(with: category, completionHandler: setBestSellers, errorHandler: printErrors)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationDVC = segue.destination as? BookDetailViewController {
            if let cell = sender as? BestSellerCollectionViewCell {
                if let selectedIndexPath = self.bestSellerCollectionView.indexPathsForSelectedItems?[0] {
                    let row = selectedIndexPath.row
                    let selectedBook = bestSellers[row]
                    destinationDVC.myBestSeller = selectedBook
                    destinationDVC.myGoogleBook = cell.myGoogleBook
                    destinationDVC.bookImage = cell.bestSellerImageView.image
                }
            }
        }
    }
    
    

}
extension BestSellersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bestSellers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = bestSellerCollectionView.dequeueReusableCell(withReuseIdentifier: "bestSellerCell", for: indexPath) as! BestSellerCollectionViewCell
        let bestSeller = bestSellers[indexPath.row]
        cell.weeksLabel.text = "\(bestSeller.weeksOnList) weeks on the best seller list"
        cell.summaryTextView.text = bestSeller.bookDetails[0].description
        configureBookImages(for: bestSeller, cell: cell)
        return cell
    }
    //function used to get book images using the google books API
    func configureBookImages(for bestSeller: BestSeller, cell: BestSellerCollectionViewCell) {
        //in the closure below I am calling the ImageAPICLient that gets images based on the passed in urlString. This closure is then used as the completion for the GoogleAPICLient
        let setGoogleBook = {(onlineBook: [GoogleBook]?) in
            if let onlineBook = onlineBook {
            cell.myGoogleBook = onlineBook[0]
            let thumbnailURL = onlineBook[0].volumeInfo.imageLinks.thumbnail
                ImageAPIClient.manager.loadImage(from: thumbnailURL, completionHandler: {cell.bestSellerImageView.image = $0}, errorHandler: {print($0)})
        }
        }
        let printErrors = {(error: Error) in
            print(error)
        }
        GoogleBooksAPIClient.manager.getBookInfo(bestSeller.bookDetails[0].ISBN13, completionHandler: setGoogleBook, errorHandler: printErrors)
        
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



