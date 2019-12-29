//
//  VideosResponse.swift
//  MovieDB
//
//  Created by Cuong on 1/23/20.
//  Copyright © 2020 CuongVX-D1. All rights reserved.
//

import Foundation
import ObjectMapper

class VideosResponse: Mappable {
    var videos = [Video]()
    
    required init(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        videos <- map["results"]
    }
}

