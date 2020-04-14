//
//  SearchMoviesResultViewController.swift
//  MovieCatalog
//
//  Created by Gennady Kaminsky on 4/13/20.
//  Copyright © 2020 Gennady Kaminsky. All rights reserved.
//

import UIKit

class SearchMoviesResultViewController: UIViewController {
 
    let SEARCH_MOVIE_RESULT_REUSE_IDENTIFIER = "SearchMovieResultReuseIdentifier"
    @IBOutlet weak var movieTable: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorMessage: UILabel!
    
    var viewModel: SearchMoviesResultViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Search Results"
        movieTable.isHidden = true
        movieTable.dataSource = self
        movieTable.register(UINib(nibName: "SearchMovieResultCell", bundle: .main),                                   forCellReuseIdentifier: SEARCH_MOVIE_RESULT_REUSE_IDENTIFIER)
        movieTable.rowHeight = UITableView.automaticDimension
        movieTable.estimatedRowHeight = 150
        movieTable.tableFooterView = UIView()
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        viewModel.loadMovies()
        viewModel.delegate = self
        
        errorView.isHidden = true
    }
}

extension SearchMoviesResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getMoviesNumber()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: SEARCH_MOVIE_RESULT_REUSE_IDENTIFIER, for: indexPath) as? SearchMovieResultCell {
            let movieInfo = viewModel.getMovieInfoBy(index: indexPath.row)
            cell.setCell(title: movieInfo.title!,
                         year: movieInfo.year!,
                         image: viewModel.getMoviePosterBy(index: indexPath.row))
            cell.selectionStyle = .none
            return cell
        }
        //should not happen
        return UITableViewCell()
    }
}

extension SearchMoviesResultViewController: SearchMoviesResultViewModelDelegate {
    func handleSuccessfulResposne() {
        DispatchQueue.main.async {
          [weak self] in
            self?.reloadData()
        }
    }
    
    func handleErorr(errorString: String) {
        DispatchQueue.main.async {
            [weak self] in
            self?.showErrorMessage(errorString: errorString)
        }
    }
    
    func handleEmptyResponse() {
        handleErorr(errorString: "There are no movies that match your criteria. Please try again")
    }
    
    private func reloadData() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        errorView.isHidden = true
        movieTable.isHidden = false
        movieTable.reloadData()
    }
    
    private func showErrorMessage(errorString: String) {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        
        errorView.isHidden = false
        errorMessage.text = errorString
    }
}
