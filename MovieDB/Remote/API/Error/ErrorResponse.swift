//
//  ErrorResponse.swift
//  Movie

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
