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
    
    required init(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        movies <- map["results"]
    }
}
