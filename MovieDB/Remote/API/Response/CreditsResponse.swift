//
//  CreditsResponse.swift
//  MovieDB
//
//  Created by Cuong on 1/4/20.
//  Copyright © 2020 CuongVX-D1. All rights reserved.
//

import ObjectMapper

class CreditResponse: Mappable {
    var id = 0
    var casts = [Cast]()
    
    required init(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        casts <- map["cast"]
    }
}
