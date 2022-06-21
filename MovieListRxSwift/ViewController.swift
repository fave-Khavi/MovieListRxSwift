//
//  ViewController.swift
//  MovieListRxSwift
//
//  Created by khavishini suresh on 17/06/2022.
//

import UIKit
//import RxSwift
//import RxCocoa

class MovieTableViewController: UITableViewController {
    
    var movies = Movies()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let movie = API(baseUrl: "https://api.themoviedb.org/3/discover/movie?api_key=328c283cd27bd1877d9080ccb1604c91")
        movie.getMovies(endPoint: "&primary_release_date.lte=2016-12-31&sort_by=release_date.desc&page=1")
        movie.completionHandler{ [weak self] (movies, status, message) in
            if status {
                guard let self = self else {return}
                guard let _movies = movies else {return}
                
                self.movies = _movies
                self.tableView.reloadData()
            }
        }
    }

//    baseUrl for posterimage "https://image.tmdb.org/t/p/w500"
    
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.results.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MovieTableViewCell
        let movie = movies.results[indexPath.row]
        cell.movieTitle?.text = movie.title
        cell.popularityLabel?.text = "\(movie.popularity!)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
