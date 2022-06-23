//
//  MovieViewModel.swift
//  MovieListRxSwift
//
//  Created by khavishini suresh on 23/06/2022.
//

import Foundation

struct MovieViewModel {
    
    
    var movie: Movie
    
    var displayTitle: String {
     
        movie.title!
    }
    
    var displayPopularity: String {
     
        return "\(movie.popularity!)"
    }
    
    
    var displayPoster: String? {
        
        return movie.poster
    }
    
    
    
    init(movie: Movie) {
        self.movie = movie
    }
}
