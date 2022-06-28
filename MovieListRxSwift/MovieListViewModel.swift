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
    
        var users = BehaviorSubject(value: Movies().results)

        var page = 1
    
        var isFetchInProgress = false
        
    func fetchMovies(pagination: Bool = false) {
            
            if page < 67 {
            
                if pagination {
                    isFetchInProgress = true
                }
            
            let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=328c283cd27bd1877d9080ccb1604c91&language=en-US&page=\(page)")
            
            
            let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
                guard let data = data else {
                    return
                }
                do {
                    let movies = try JSONDecoder().decode(Movies.self, from: data)
                    self.users.onNext(movies.results)
                    self.isFetchInProgress = false
                } catch {
                    self.users.onError(error)
                }
            }
            
            task.resume()
            }
            print(page)
            
        page = page + 1
        
        if pagination {
            self.isFetchInProgress = false
        }
    }
}
