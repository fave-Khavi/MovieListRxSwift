//
//  MovieListViewModel.swift
//  MovieListRxSwift
//
//  Created by khavishini suresh on 23/06/2022.
//

import Foundation
import RxSwift
import RxCocoa

class MovieListViewModel {
    
    
    private let bag = DisposeBag()
    private let movieAPI = MovieAPI()

    let movies = BehaviorRelay<[Movie]>(value: [])
    
    private var page = 1
    private var totalPages = 1
    private var isFetchInProgress = false
    
    let fetchMoreMovies = PublishSubject<Void>()
    
    init() {
        bind()
    }

   private func bind() {

        fetchMoreMovies.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.fetchMovies(page: self.page)
        }
        .disposed(by: bag)
    }
        
    func fetchMovies(page: Int) {
        if isFetchInProgress { return }
        
        if page > totalPages  {
            isFetchInProgress = false
            return
        }
       
        isFetchInProgress = true
        
        movieAPI.getMovie(page: page) { [weak self] movieData in
            self?.handleMovies(movie: movieData)
            self?.isFetchInProgress = false
            
        }
    }
    
    private func handleMovies(movie: Movies) {

        totalPages = movie.total_pages
        if page == 1, let allMovies = movie.results {
            self.totalPages = movie.total_pages
            movies.accept(allMovies)
        } else if let movie = movie.results {
            let previousMovies = movies.value
            movies.accept(previousMovies + movie)
        }
        page += 1
    }

}
