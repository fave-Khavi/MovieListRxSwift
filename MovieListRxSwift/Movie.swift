//
//  Movie.swift
//  MovieListRxSwift
//
//  Created by khavishini suresh on 19/06/2022.
//

import Foundation

//Movie List
struct Result: Decodable {
    var title: String!
    var popularity: Double!
    var poster: String!
    
    enum CodingKeys: String, CodingKey {
        case title
        case popularity = "popularity"
        case poster = "poster_path"
    }
    init() {
        title = nil
        popularity = nil
        poster = nil
    }
}
