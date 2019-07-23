//
//  Cast.swift
//  MovieDB
//
//  Created by CuongVX-D1 on 7/23/19.
//  Copyright © 2019 CuongVX-D1. All rights reserved.
//

import ObjectMapper

struct Cast: Mappable {
    var castId: Int = 0
    var character = ""
    var creditId = ""
    var gender: Int = 0
    var id: Int = 0
    var name = ""
    var order: Int = 0
    var profilePath = ""
    
    init?(map: Map) {
    }
    
    init(){
    }
    
    mutating func mapping(map: Map) {
        castId <- map["cast_id"]
        character <- map["character"]
        creditId <- map["credit_id"]
        gender <- map["gender"]
        id <- map["id"]
        name <- map["name"]
        order <- map["order"]
        profilePath <- map["profile_path"]
    }
}
