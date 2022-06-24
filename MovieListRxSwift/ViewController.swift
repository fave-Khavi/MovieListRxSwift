//
//  ViewController.swift
//  MovieListRxSwift
//
//  Created by khavishini suresh on 17/06/2022.
//

import UIKit
import RxSwift
import RxCocoa

class MovieTableViewController: UITableViewController {
    
    private var viewModel: MovieListViewModel!
 
    
    //Init viewModel to viewController
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        viewModel = MovieListViewModel()
    }
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = nil
        bindTableView()
        
        
        //Prints data in console
        let service = MovieService()
        service.fetchMovies().subscribe(onNext: { movies in
            print("fetch data")
        }).disposed(by: bag)
        
    }
    
    //Pull to refresh
    @IBAction func refresh(_ sender: UIRefreshControl) {
        tableView.dataSource = nil
        print("refreshing data")
        
        bindTableView()
        print("refreshed data")
        
        tableView.refreshControl?.endRefreshing()
        tableView.reloadData()
    }
    
    //Bind data to the tableView
    private func bindTableView() {
        viewModel.fetchMovieViewModels().observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: MovieTableViewCell.self)) { index, viewModel, cell in
                cell.movieTitle?.text = viewModel.displayTitle
                cell.popularityLabel?.text = viewModel.displayPopularity
                
                guard let img = viewModel.displayPoster else {
                    cell.posterImage.image = UIImage(named: "NoPoster")
                    return
                }
                cell.posterImage.downloaded(from: "https://image.tmdb.org/t/p/w500" + img)
                
            }.disposed(by: bag)
    }
}
