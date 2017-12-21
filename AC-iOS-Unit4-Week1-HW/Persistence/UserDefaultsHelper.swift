//
//  UserDefaultsHelper.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/21/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation
class UserDefaultsHelper {
    private init() {}
    static let manager = UserDefaultsHelper()
    private let myKey = "default"
    private let defaults = UserDefaults.standard
    
    //this struct is applicable for this app. prob not best mvc! REFACTOR
    struct PickerDefaults: Codable {
        let title: String
        let pickerNum: Int
    }
    
    func setDefault(defaultVal: PickerDefaults) {
        do {
            //encode default into data
            let data = try PropertyListEncoder().encode(defaultVal)
            //set default
            defaults.set(data, forKey: myKey)
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func getSetting() -> PickerDefaults? {
        guard let data = defaults.data(forKey: myKey) else {return nil}
        do {
            let myDefaults = try PropertyListDecoder().decode(PickerDefaults.self, from: data)
            return myDefaults
        }
        catch {
            print(error)
            return nil 
        }
    }
    
    
    
    
}
