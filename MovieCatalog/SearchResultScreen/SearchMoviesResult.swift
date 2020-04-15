//
//  SearchMoviesResult.swift
//  MovieCatalog
//
//  Created by Gennady Kaminsky on 4/13/20.
//  Copyright © 2020 Gennady Kaminsky. All rights reserved.
//

import Foundation

// This defines data model for movie search server response.
struct MovieInfo {
    var title: String?
    var year: String?
    var type: String?
    var poster: String?
}

struct SearchMoviesResult {
    var collection: [MovieInfo]?
    var response: String
    var error: String?
}

extension SearchMoviesResult: Decodable {
    enum CodingKeys: String, CodingKey {
        case collection = "Search"
        case response = "Response"
        case error = "Error"
    }
}

extension MovieInfo: Decodable {
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case poster = "Poster"
        case type = "Type"
    }
}
