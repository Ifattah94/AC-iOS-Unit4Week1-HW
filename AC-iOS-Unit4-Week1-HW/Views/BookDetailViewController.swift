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
    func setup() {
        titleLabel.text = myBestSeller?.bookDetails[0].title ?? ""
        subtitleLabel.text = myGoogleBook?.searchInfo.textSnippet ?? ""
        summaryTextView.text = myGoogleBook?.volumeInfo.description ?? ""
        bookImageView.image = bookImage

    }



}
