//
//  ViewController.swift
//  MovieListRxSwift
//
//  Created by khavishini suresh on 17/06/2022.
//

import UIKit
import RxSwift
import RxCocoa

class MovieTableViewController: UIViewController, UITableViewDelegate, UIScrollViewDelegate {
    
    private var viewModel = MovieListViewModel()
    private var bag = DisposeBag()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindTableView()
        DispatchQueue.main.async {
            self.viewModel.fetchMoreMovies.onNext(())
        }
        //Pull to refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    //Pull to refresh
    @objc func refresh(refreshControl: UIRefreshControl) {
        
        tableView.dataSource = nil
        print("refreshing data")
        bindTableView()
        print("refreshed data")
        tableView.refreshControl?.endRefreshing()
        tableView.reloadData()
    }
    
    
    func bindTableView() {
        //Bind data to the tableView
        viewModel.movies.bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: MovieTableViewCell.self)) { index, viewModel, cell in
            
                cell.movieTitle?.text = viewModel.title
                cell.popularityLabel?.text = "\(viewModel.popularity!)"
                
            if viewModel.poster != nil {
                let imgUrl = "https://image.tmdb.org/t/p/w500" + viewModel.poster!
                cell.posterImage.downloaded(from: imgUrl)
            } else {
                cell.posterImage.image = UIImage(named: "NoPoster")
            }
            
            }.disposed(by: bag)
    
        //Get more data when scrolled to bottom
        tableView.rx.didScroll.subscribe { [weak self] _ in
            guard let self = self else { return }
            let offSetY = self.tableView.contentOffset.y
            let contentHeight = self.tableView.contentSize.height

            if offSetY > (contentHeight - self.tableView.frame.size.height - 100) {
                self.viewModel.fetchMoreMovies.onNext(())
            }
        }
        .disposed(by: bag)
    }
}
