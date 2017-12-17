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
    
    
    var categories = [Category]() {
        didSet {
            self.categoryPickerView.reloadAllComponents()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.categoryPickerView.delegate = self
        self.categoryPickerView.dataSource = self
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
    
}
