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
        
        title = "MovieListScreen.viewTitle".localized
        
        // Configure movieTable
        movieTable.isHidden = true
        movieTable.dataSource = self
        movieTable.register(UINib(nibName: "SearchMovieResultCell", bundle: .main),                                   forCellReuseIdentifier: SEARCH_MOVIE_RESULT_REUSE_IDENTIFIER)
        movieTable.rowHeight = UITableView.automaticDimension
        movieTable.estimatedRowHeight = 150
        movieTable.tableFooterView = UIView()
        
        // Configure activity indicator. Should be displayed when this view shows up.
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        
        // Start loading movies
        viewModel.loadMovies()
        viewModel.delegate = self
        
        // Error view is hidden
        errorView.isHidden = true
    }
}

// The code below populates table with movies data.
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
    
    // This function is called when the viewModel recieves and parses data successfully.
    func handleSuccessfulResposne() {
        // Since it is called from network thread and needs to update UI elements
        // force its execution on main thread.
        DispatchQueue.main.async {
          [weak self] in
            self?.reloadData()
        }
    }
    
    // This function is called when there is an error recieving data by viewModel
    // Error to dispaly is passed in
    func handleErorr(errorString: String) {
        // Since it is called from network thread and needs to update UI elements
        // force its execution on main thread.
        DispatchQueue.main.async {
            [weak self] in
            self?.showErrorMessage(errorString: errorString)
        }
    }
    
    // This functon is called when search ends up in empty result set.
    func handleEmptyResponse() {
        handleErorr(errorString: "There are no movies that match your criteria. Please try again")
    }
    
    // Helper functions
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
