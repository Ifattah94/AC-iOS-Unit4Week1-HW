//
//  PersistenceManager.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/20/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit
class PersistenceManager {
    
static let kPathName = "favorites.plist"
    private init() {}
    static let manager = PersistenceManager()
    
    private var favorites = [Favorite]() {
        didSet {
            
        }
    }
    // returns documents directory path for app
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
    // returns the path depending on the directory
    func dataFilePath(withPathName path: String) -> URL {
        return PersistenceManager.manager.documentsDirectory().appendingPathComponent(path)
    }
    
    // save to documents directory
    func saveFavorites() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(favorites)
            try data.write(to: dataFilePath(withPathName: PersistenceManager.kPathName), options: .atomic)
        } catch {
            print("encoding error: \(error.localizedDescription)")
        }
        
    }
    //loading data from decoder
    func load() {
        let path = dataFilePath(withPathName: PersistenceManager.kPathName)
        let decoder = PropertyListDecoder()
        do {
            let data = try Data.init(contentsOf: path)
            favorites = try decoder.decode([Favorite].self, from: data)
        } catch {
            print("decoding error: \(error.localizedDescription)")
        }
    }
    
    func addFavoriteBook(bestSeller: BestSeller, googleBook: GoogleBook, image : UIImage) {
        let isbnExist = favorites.index{$0.isbn == bestSeller.bookDetails[0].ISBN13}
        if isbnExist != nil { print("FAVORITE EXIST"); return }
        guard let imageData = UIImagePNGRepresentation(image) else {return}
        let imageURL = PersistenceManager.manager.dataFilePath(withPathName: "\(bestSeller.bookDetails[0].ISBN13)")
        do {
            try imageData.write(to: imageURL)
        }
        catch {
            print("image saving error: \(error.localizedDescription)")
        }
        let newFavorite = Favorite.init(title: bestSeller.bookDetails[0].title, isbn: bestSeller.bookDetails[0].ISBN13, summary: googleBook.volumeInfo.description ?? "")
        favorites.append(newFavorite)
    }
    
    func getFavorites() -> [Favorite] {
        return favorites
    }
    func isBookInFavorites(bestSeller: BestSeller) -> Bool {
         let isbnExist = favorites.index{$0.isbn == bestSeller.bookDetails[0].ISBN13}
        if isbnExist != nil {
            return true
        } else {
            return false
        }
    }
    
    func getFavoriteWithISBN(isbn: String) -> Favorite? {
        let index = getFavorites().index{$0.isbn == isbn}
        guard let indexFound = index else {return nil}
        return favorites[indexFound]
    }
    func removeFavorite(from index: Int, favorite: Favorite) -> Bool {
        favorites.remove(at: index)
        let url = PersistenceManager.manager.dataFilePath(withPathName: favorite.isbn)
        do {
            try FileManager.default.removeItem(at: url)
            return true
        }
        catch {
            print(error.localizedDescription)
            return false
        }
    }
    
}
