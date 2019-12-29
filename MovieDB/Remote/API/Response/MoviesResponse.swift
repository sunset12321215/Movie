//
//  MoviesResponse.swift
//  MovieDB
//
//  Created by CuongVX-D1 on 7/23/19.
//  Copyright © 2019 CuongVX-D1. All rights reserved.
//

import ObjectMapper

class MoviesResponse: Mappable {
    var movies = [Movie]()
    var totalPages = 0
    
    required init(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        movies <- map["results"]
        totalPages <- map["total_pages"]
    }
}

class MoviesByCastResponse: Mappable {
    var movies = [Movie]()
    
    required init(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        movies <- map["cast"]
    }
}
