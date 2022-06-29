//
//  Movies.swift
//  MovieListRxSwift
//
//  Created by khavishini suresh on 20/06/2022.
//

import Foundation

struct Movies: Decodable {
    var page: Int!
    var total_pages: Int!
    var results: [Movie]?
    
    enum CodingKeys: String, CodingKey {
        case page = "page"
        case total_pages = "total_pages"
        case results = "results"
    }
    
    init() {
        self.page = nil
        self.total_pages = nil
        self.results = []
    }
}

