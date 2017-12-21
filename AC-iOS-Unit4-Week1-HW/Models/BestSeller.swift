//
//  BestSeller.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/16/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation
struct BestSellerInfo: Codable {
    let results: [BestSeller]
}
struct BestSeller: Codable {
    let weeksOnList: Int
    let bookDetails:[BookInfo]
    enum CodingKeys: String, CodingKey {
        case weeksOnList = "weeks_on_list"
        case bookDetails = "book_details"
    }
    
}
struct BookInfo: Codable {
    let title: String
    let description: String
    let author: String
    let ISBN13: String
    let ISBN10: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case author
        case ISBN13 = "primary_isbn13"
        case ISBN10 = "primary_isbn10"
        
        
    }
}
struct BestSellerAPIClient {
    private init() {}
    static let manager = BestSellerAPIClient()
    func getBestSellers(with category: String, completionHandler: @escaping ([BestSeller]) -> Void, errorHandler: @escaping (Error) -> Void) {
        let urlStr = "https://api.nytimes.com/svc/books/v3/lists.json?api-key=6c126b17173a46698e69341eac33049b&list=\(category)"
        guard let url = URL(string: urlStr) else {
            errorHandler(AppError.badURL(str: urlStr))
            return
        }
        let request = URLRequest(url:url)
        let parseDataInto: (Data) -> Void = {(data) in
            do {
                let results = try JSONDecoder().decode(BestSellerInfo.self, from: data)
                
            let bestSellers = results.results
            completionHandler(bestSellers)
            }
            catch {
                errorHandler(AppError.codingError(rawError: error))
            }
        }
        NetworkHelper.manager.performDataTask(with: request, completionHandler: parseDataInto, errorHandler: errorHandler)
    }
    
}











