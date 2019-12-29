//
//  Cast.swift
//  MovieDB
//
//  Created by CuongVX-D1 on 7/23/19.
//  Copyright © 2019 CuongVX-D1. All rights reserved.
//

import ObjectMapper

class Cast: Mappable {
    var id = 0
    var name =  ""
    var profilePath = ""
    var gender = 0
    var knownForDepartment = ""
    var biography = ""
    var placeOfBirth = ""
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        profilePath <- map["profile_path"]
        gender <- map["gender"]
        placeOfBirth <- map["placeOfBirth"]
        knownForDepartment <- map["known_for_department"]
        biography <- map["biography"]
    }
}

