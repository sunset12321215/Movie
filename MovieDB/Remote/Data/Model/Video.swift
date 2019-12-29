//
//  Video.swift
//  MovieDB
//
//  Created by Cuong on 1/23/20.
//  Copyright © 2020 CuongVX-D1. All rights reserved.
//

import Foundation
import ObjectMapper

class Video: Mappable {
    var id: String = ""
    var key: String = ""
    var name: String = ""
    var site: String = ""
    var size: Int = 0
    var type: String = ""
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        key <- map["key"]
        name <- map["name"]
        site <- map["site"]
        size <- map["size"]
        type <- map["type"]
    }
}
