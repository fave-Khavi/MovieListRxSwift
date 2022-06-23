//
//  MovieListViewModel.swift
//  MovieListRxSwift
//
//  Created by khavishini suresh on 23/06/2022.
//

import Foundation
import RxSwift

class MovieListViewModel {
    
    let title = "Movies"
    
    private let movieService: MovieServiceProtocol
    
    init(movieService: MovieServiceProtocol = MovieService()){
        self.movieService = movieService
    }
    
    func fetchMovieViewModels() -> Observable<[MovieViewModel]> {
        
        movieService.fetchMovies().map { $0.results.map {
            MovieViewModel(movie: $0)
        } }
    
    }
    
}
