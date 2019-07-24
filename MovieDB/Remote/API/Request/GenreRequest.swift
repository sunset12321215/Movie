//
//  GenreRequest.swift
//  MovieDB
//
//  Created by CuongVX-D1 on 7/24/19.
//  Copyright © 2019 CuongVX-D1. All rights reserved.
//

import Foundation

class GenreRequest: BaseRequest {
    required init() {
        let body: [String: Any] = [
            "language": "en-US"
        ]
        super.init(url: URLs.APIGenreListURL, requestType: .get, body: body)
    }
}
