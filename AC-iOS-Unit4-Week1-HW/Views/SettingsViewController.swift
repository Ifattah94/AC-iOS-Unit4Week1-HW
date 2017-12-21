//
//  SettingsViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/16/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    
    @IBOutlet weak var settingsPickerView: UIPickerView!
    
    var categories = [Category]() {
        didSet {
            settingsPickerView.reloadAllComponents()
            if let settings = UserDefaultsHelper.manager.getSetting() {
                settingsPickerView.selectRow(settings.pickerNum, inComponent: 0, animated: true)
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsPickerView.dataSource = self
        settingsPickerView.delegate = self
        setCategories()

    }

    func setCategories() {
        let setCategories = {(onlineCategories: [Category]) in
            self.categories = onlineCategories
        }
        let printErrors = {(error: Error) in
            print(error)

}
        CategoryAPIClient.manager.getCategories(completionHandler: setCategories, errorHandler: printErrors)
}
    
}
extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        
        let selectedSetting = UserDefaultsHelper.PickerDefaults(title: categories[row].displayName, pickerNum: row)
        
        UserDefaultsHelper.manager.setDefault(defaultVal: selectedSetting)

    }
}








