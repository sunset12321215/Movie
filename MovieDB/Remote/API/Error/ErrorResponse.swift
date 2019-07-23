//
//  ErrorResponse.swift
//  Movie
//
//  Created by pham.xuan.tien on 12/28/18.
//  Copyright © 2018 Framgia. All rights reserved.
//

import ObjectMapper

class ErrorResponse: Mappable {
    var documentationUrl = ""
    var message = ""

    required init?(map: Map) {
        mapping(map: map)
    }

    func mapping(map: Map) {
        documentationUrl <- map["documentation_url"]
        message <- map["message"]
    }
}
