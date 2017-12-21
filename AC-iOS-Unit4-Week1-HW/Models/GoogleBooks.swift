//
//  GoogleBooks.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/20/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation



struct GoogleBooksInfo: Codable {
    let items: [GoogleBook]?
}

struct GoogleBook: Codable {
    let volumeInfo: VolumeInfoWrapper
    let searchInfo: SearchInfoWrapper
}

struct VolumeInfoWrapper: Codable {
    let title: String
    let authors: [String]
    let description: String?
    let imageLinks: ImageWrapper
}

struct ImageWrapper: Codable {
    let thumbnail: String
}

struct SearchInfoWrapper: Codable {
    let textSnippet: String?
}

class GoogleBooksAPIClient {
    private init() {}
    static let manager = GoogleBooksAPIClient()
    let myGoogleKey = "AIzaSyDDmn8l0B_2nz2WpyeGTT7JMn-WEcRSQWU"
    func getBookInfo(_ isbn: String, completionHandler: @escaping ([GoogleBook]?) -> Void, errorHandler: @escaping (Error) -> Void) {
         let urlStr = "https://www.googleapis.com/books/v1/volumes?q=+isbn:\(isbn)&key=\(myGoogleKey)"
        //turn string into URL
        guard let url = URL(string: urlStr) else {errorHandler(AppError.badURL(str: urlStr)); return}
        //turn url into url request
        let request = URLRequest(url: url)
        //completion handler to decode data into GoogleBook object
        let parseDataIntoBooks: (Data) -> Void = {(data: Data) in
            do {
                let results = try JSONDecoder().decode(GoogleBooksInfo.self, from: data)
                if let books = results.items {
                    completionHandler(books)
                } else {
                    //print("no book")
                }
            }
            catch {
                print(errorHandler(AppError.codingError(rawError: error)))
            }
        }
        NetworkHelper.manager.performDataTask(with: request, completionHandler: parseDataIntoBooks, errorHandler: errorHandler)
    }
}


