//
//  BookDetailViewController.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/16/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController {

    
    @IBOutlet weak var bookImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subtitleLabel: UILabel!
    
   
    @IBOutlet weak var summaryTextView: UITextView!
 
    var bookImage: UIImage?
    var myBestSeller: BestSeller?
    var myGoogleBook: GoogleBook?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()


    }
    
    
    @IBAction func favoritesButtonPressed(_ sender: UIButton) {
        guard let myBestSeller = myBestSeller else {return}
        
        if PersistenceManager.manager.isBookInFavorites(bestSeller: myBestSeller) {
        showAlert2()
        removeFavorite()
        PersistenceManager.manager.saveFavorites()
        
        } else {
            if let myGoogleBook = myGoogleBook, let bookImage = bookImage {
            showAlert()
            PersistenceManager.manager.addFavoriteBook(bestSeller: myBestSeller, googleBook: myGoogleBook, image: bookImage)
                PersistenceManager.manager.saveFavorites()
            }
        }
        
    }
    
    
    
    
    private func showAlert() {
        let alertController = UIAlertController(title: "Success", message: "Added to Favorites!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    private func showAlert2() {
        let alertController = UIAlertController(title: "Success", message: "Removed from Favorites!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
    func setup() {
        if let myBestSeller = myBestSeller, let myGoogleBook = myGoogleBook {
        titleLabel.text = myBestSeller.bookDetails[0].title
        subtitleLabel.text = myGoogleBook.volumeInfo.subtitle ?? ""
        summaryTextView.text = myGoogleBook.volumeInfo.description ?? ""
        bookImageView.image = bookImage
        } else {
            bookImageView.image = #imageLiteral(resourceName: "noImage")
        }
    }
    
    private func removeFavorite() {
        if let myBestSeller = myBestSeller{
            guard let favoriteToBeRemoved = PersistenceManager.manager.getFavoriteWithISBN(isbn: myBestSeller.bookDetails[0].ISBN13) else {return}
            let index = PersistenceManager.manager.getFavorites().index{$0.isbn == myBestSeller.bookDetails[0].ISBN13}
            if let index = index {
                let _ = PersistenceManager.manager.removeFavorite(from: index, favorite: favoriteToBeRemoved)
            }
            
        }
    }



}
