//
//  Genre.swift
//  MovieDB
//
//  Created by CuongVX-D1 on 7/23/19.
//  Copyright © 2019 CuongVX-D1. All rights reserved.
//

import ObjectMapper

final class Genre: Mappable {
    var id: Int = 0
    var name = ""
    
    required init?(map: Map) {
    }
    
    required init() {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
}
