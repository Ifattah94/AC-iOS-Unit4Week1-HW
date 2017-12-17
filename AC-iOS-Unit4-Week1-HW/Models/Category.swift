//
//  Category.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/16/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation


struct CategoryInfo: Codable {
    let results: [Category]
}
struct Category: Codable {
    let displayName: String
    let encodedListName: String
    
    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
        case encodedListName = "list_name_encoded"
        
    }
}

struct CategoryAPIClient {
    private init() {}
    static let manager = CategoryAPIClient()
    private let nytAPIKey = "6c126b17173a46698e69341eac33049b"
    private let urlStr = "https://api.nytimes.com/svc/books/v3/lists/names.json?api-key=6c126b17173a46698e69341eac33049b"
    func getCategories(completionHandler: @escaping ([Category]) -> Void, errorHandler: @escaping (Error) -> Void) {
        guard let url = URL(string: urlStr) else {
            errorHandler(AppError.badURL(str: urlStr))
            return
        }
        let request = URLRequest(url:url)
        let parseDataIntoCategories: (Data) -> Void = {(data) in
            do {
                let results = try JSONDecoder().decode(CategoryInfo.self, from: data)
                let categories = results.results
                completionHandler(categories)
            }
            catch {
                errorHandler(AppError.codingError(rawError: error))
            }
        }
        NetworkHelper.manager.performDataTask(with: request, completionHandler: parseDataIntoCategories, errorHandler: errorHandler)
    }

    
}
