//
//  API.swift
//  MovieListRxSwift
//
//  Created by khavishini suresh on 17/06/2022.
//

import Foundation
import RxSwift

protocol MovieServiceProtocol {
    func fetchMovies() -> Observable<Movies>
}

class MovieService: MovieServiceProtocol {
    
    func fetchMovies() -> Observable<Movies> {
        
        return Observable.create { observer -> Disposable in
            
            
            //URL API
            let task = URLSession.shared.dataTask(with: URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=328c283cd27bd1877d9080ccb1604c91&language=en-US&page=1")!) {
                data, _, _ in
                
                guard let data = data else {
                    observer.onError(NSError(domain: "", code: -1, userInfo: nil))
                    return
                }
                do {
                    let movies = try JSONDecoder().decode(Movies.self, from: data)
                    observer.onNext(movies)
                } catch {
                    observer.onError(error)
                }
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
