//
//  SearchMoviesResultViewModel.swift
//  MovieCatalog
//
//  Created by Gennady Kaminsky on 4/13/20.
//  Copyright © 2020 Gennady Kaminsky. All rights reserved.
//

import Foundation

protocol SearchMoviesResultViewModelProtocol {
    func loadMovies()
    var delegate: SearchMoviesResultViewModelDelegate! { set get }
    func getMoviesNumber() -> Int
    func getMovieInfoBy(index: Int) -> MovieInfo
    func getMoviePosterBy(index: Int) -> Data?
}

protocol SearchMoviesResultViewModelDelegate: class {
    func handleSuccessfulResposne()
    func handleErorr(errorString: String)
    func handleEmptyResponse()
}

class SearchMoviesResultViewModel: SearchMoviesResultViewModelProtocol {
    
    var title: String
    var movieType: String
    var client: SearchMoviewResultClientProtocol
    let baseURL = "http://www.omdbapi.com/?apikey=acb95f63"
    
    var moviesCollection: [MovieInfo]
    var moviesPoster: [Data?]
    
    weak var delegate: SearchMoviesResultViewModelDelegate!

    init(title: String, movieType: String, client: SearchMoviewResultClientProtocol) {
        self.title = title
        self.movieType = movieType
        self.client = client
        self.moviesCollection = [MovieInfo]()
        self.moviesPoster = [Data?]()
        self.client.delegate = self
    }
    
    func loadMovies() {
        var url = baseURL
        
        if title != "" {
            url = url + "&s=\(title)"
        }
        
        if movieType != "" {
            url = url + "&type=\(movieType)"
        }
        
        client.loadMoviews(url: url)
    }
    
    func getMovieInfoBy(index: Int) -> MovieInfo {
        return moviesCollection[index]
    }
    
    func getMoviePosterBy(index: Int) -> Data? {
        return moviesPoster[index]
    }
    
    func getMoviesNumber() -> Int {
        return moviesCollection.count
    }
    
    private func fetchPosterImagesForMovies() {
        let size = moviesCollection.count
        
        for _ in 0 ..< size {
            moviesPoster.append(nil)
        }
        
        // Since poster images for each movie is independent from each other
        // we will load them in parallel. We will use distapth group to
        // achieve this.
        // If a specific image load request fails, we won't treat it as a failure.
        // We will rather not show the image in this case.
        
        let group = DispatchGroup()
        for index in 0 ..< size {
            group.enter()
            if let url = moviesCollection[index].poster {
                client.loadImage(url: url, index: index) {
                    [weak self] data, index in
                    
                    self?.moviesPoster[index] = data
                    
                    group.leave()
                }
            } else {
                group.leave()
            }
        }
        
        // All requests are made. Wait until we get notified
        // that all requests have returned.
        group.notify(queue: .main) {
            [weak self] in
            self?.delegate?.handleSuccessfulResposne()
        }
    }
}

extension SearchMoviesResultViewModel: SearchoviewResultModelDelegateProtocol {
    func handleSuccessfulResponse(movies: SearchMoviesResult) {
        if movies.response == "True" {
            if let collection = movies.collection {
                moviesCollection.append(contentsOf: collection)
                fetchPosterImagesForMovies()
            } else {
                // no movies returned. According to APis this should not
                // happen. When no movies retuned, the movies.response shuould be
                // false and movies.error should  be set. Treat it as an successfull
                // case with empty screen.
                delegate?.handleEmptyResponse()
            }
        } else {
            // there is an error finding a movie. Most likely no movie was found
            // based on criteria. In this case movies.error should have an error message.
            // We should get all possivble error messages from APi so we can properly map
            // it to a display string so translation can be done.
            // For testing purposes we will treat it empty case scenario.
            delegate?.handleEmptyResponse()
        }
    }
    
    func handleHTTPNetworkError(statusCode: Int) {
        // should get a error message to tell view controller to display based on status code.
        // For testing purposes will use generic message
        
        delegate?.handleErorr(errorString: "Something went wrong. Please try again later")
    }
    
    func handleNetworkError(error: Error) {
        // should get a error message to tell view controller to display based on error returned
        // For testing purposes will use generic message
        
        delegate?.handleErorr(errorString: "Something went wrong. Please try again later")
    }
    
    func handleParsedError() {
        // this error indicates that somethng is wrong with the server. We should not get this
        // error if APIs work properly.
        
        delegate?.handleErorr(errorString: "Something went wrong. We are working to resolve an issue.")
    }
}
