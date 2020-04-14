//
//  SearchMoviewResultClient.swift
//  MovieCatalog
//
//  Created by Gennady Kaminsky on 4/13/20.
//  Copyright © 2020 Gennady Kaminsky. All rights reserved.
//

import Foundation

protocol SearchMoviewResultClientProtocol {
    func loadMoviews(url: String)
    func loadImage(url: String, index: Int, callback: @escaping (Data?, Int) -> Void)
    var delegate: SearchoviewResultModelDelegateProtocol! { set get }
}

protocol SearchoviewResultModelDelegateProtocol: class {
    func handleHTTPNetworkError(statusCode: Int)
    func handleSuccessfulResponse(movies: SearchMoviesResult)
    func handleNetworkError(error: Error)
    func handleParsedError()
}

class SearchMoviewResultClient: SearchMoviewResultClientProtocol {
    var networkService: NetworkServiceProtocol
    weak var delegate: SearchoviewResultModelDelegateProtocol!
    var callback: ((Data?, Int) -> Void)?
    
    init(networkService: NetworkServiceProtocol = NetworkService(session: URLSession.shared)) {
        self.networkService = networkService
    }
    
    func loadMoviews(url: String) {
        networkService.request(url: url, method: "GET", headers: [:]) {
            [weak self] data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                // http error
                self?.delegate.handleHTTPNetworkError(statusCode: httpResponse.statusCode)
                return
            }
            
            if error != nil {
                // some server error
                self?.delegate.handleNetworkError(error: error!)
                return
            }
            
            if let data = data {
                let decoder = JSONDecoder()
                if let parsedData = try? decoder.decode(SearchMoviesResult.self, from: data) {
                    self?.delegate.handleSuccessfulResponse(movies: parsedData)
                } else {
                    // error parsing response. Should not really happen
                    self?.delegate.handleParsedError()
                }
            }
        }
    }
    
    func loadImage(url: String, index: Int, callback: @escaping (Data?, Int) -> Void) {
        self.callback = callback
        
        // we need to make this request in async loop because
        // Data(contentsOf: url) call is synchronious.
        if let urlFetch = URL(string: url) {
            DispatchQueue.global().async {
               [weak self] in
                   let data = try? Data(contentsOf: urlFetch)
                   self?.callback?(data, index)
           }
        }
    }
}
