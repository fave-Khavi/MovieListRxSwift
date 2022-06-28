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
    
    var isPaginating = false
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.fetchMovies(pagination: false)
        bindTableView()
        bindMore()
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
    
    //Used for tableViewController
   /* @IBAction func refresh(_ sender: UIRefreshControl) {
        tableView.dataSource = nil
        print("refreshing data")
        
        bindTableView()
        print("refreshed data")
        
        tableView.refreshControl?.endRefreshing()
        tableView.reloadData()
    } */
    
    
    //Bind data to the tableView
    func bindTableView() {
        
        viewModel.users.bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: MovieTableViewCell.self)) { index, viewModel, cell in
                cell.movieTitle?.text = viewModel.title
                cell.popularityLabel?.text = "\(viewModel.popularity!)"
                
            if viewModel.poster != nil {
                let imgUrl = "https://image.tmdb.org/t/p/w500" + viewModel.poster!
                cell.posterImage.downloaded(from: imgUrl)
            } else {
                cell.posterImage.image = UIImage(named: "NoPoster")
            }
            
            }.disposed(by: bag)
    }
    
    private func createSpinerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        
        return footerView
    }
    
    func bindMore() {
            tableView.rx.didScroll.subscribe{ [weak self] _ in
                guard let self = self else { return }
                let offSetY = self.tableView.contentOffset.y
                let contentHeight = self.tableView.contentSize.height
                
                if offSetY > (contentHeight - self.tableView.frame.size.height - 100) {
                    guard !self.viewModel.isFetchInProgress else {
                        return
                    }
                    self.viewModel.fetchMovies(pagination: true)
                        DispatchQueue.main.async {
                            self.tableView.tableFooterView = nil
                        }
                }
            }.disposed(by: bag)
        }
    
}
    

