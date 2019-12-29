//
//  CastResponse.swift
//  MovieDB
//
//  Created by Cuong on 1/31/20.
//  Copyright © 2020 CuongVX-D1. All rights reserved.
//

import Foundation
import ObjectMapper

class CastResponse: Mappable {
    var cast = Cast()
    var birthday = ""
    var knownForDepartment = ""
    var id = 0
    var name = ""
    var alsoKnownAs = [String]()
    var gender = 0
    var biography = ""
    var popularity: Float = 0
    var placeOfBirth = ""
    var profilePath = ""
    var adult = false
    var imdbId = ""
    var homepage = ""
    
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    required init() {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        birthday <- map["birthday"]
        knownForDepartment <- map["known_for_department"]
        name <- map["name"]
        alsoKnownAs <- map["also_known_as"]
        gender <- map["gender"]
        biography <- map["biography"]
        popularity <- map["popularity"]
        placeOfBirth <- map["place_of_birth"]
        profilePath <- map["profile_path"]
        adult <- map["adult"]
        imdbId <- map["imdb_id"]
        homepage <- map["homepage"]
    }
}
