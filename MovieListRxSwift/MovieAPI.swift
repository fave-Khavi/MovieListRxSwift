//
//  MovieAPI.swift
//  MovieListRxSwift
//
//  Created by khavishini suresh on 29/06/2022.
//

import Foundation

struct MovieAPI {
    func getMovie(page: Int, completion: @escaping (Movies)->()) {
       
        let api = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=328c283cd27bd1877d9080ccb1604c91&language=en-US&page=\(page)")
        
        URLSession.shared.dataTask(with: api!) {
            data, response,error in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            do {
                let movies = try JSONDecoder().decode(Movies.self,from: data!)
                completion(movies)
            } catch {
                
            }
        }.resume()
        
        print("Page: \(page)")
        
    }
}
