//
//  Favorite.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/20/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit
struct Favorite: Codable {
    let title: String
    let isbn: String
    let summary: String
    var image: UIImage? {
        set{}
        get {
            let imageURL = PersistenceManager.manager.dataFilePath(withPathName: isbn)
            let docImage = UIImage(contentsOfFile: imageURL.path)
            return docImage
        }
    }
    
}
