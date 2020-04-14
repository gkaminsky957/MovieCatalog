//
//  NetworkService.swift
//  MovieCatalog
//
//  Created by Gennady Kaminsky on 4/13/20.
//  Copyright © 2020 Gennady Kaminsky. All rights reserved.
//

import Foundation

protocol NetworkServiceProtocol {
    func request(url: String, method: String, headers: [String: String], callback: @escaping  (Data?, URLResponse?, Error?) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    var session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func request(url: String, method: String, headers: [String: String], callback: @escaping  (Data?, URLResponse?, Error?) -> Void) {
        var request = URLRequest(url: URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
        request.httpMethod = method
        
        for (_, value) in headers.enumerated() {
            request.setValue(value.value, forHTTPHeaderField: value.key)
        }
                
        let task = session.dataTask(with: request) {
            data, response, error in
            callback(data, response, error)
        }
        task.resume()
    }
}
