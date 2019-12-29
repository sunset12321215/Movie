//
//  SearchRequest.swift
//  MovieDB
//
//  Created by Cuong on 1/21/20.
//  Copyright © 2020 CuongVX-D1. All rights reserved.
//

import Foundation

class SearchRequest: BaseRequest {
    required init(text: String, page: Int) {
        let body: [String: Any] = [
            "language": "en-US",
            "query": text,
            "page": page
        ]
        let url = URLs.APISearchURL
        super.init(url: url, requestType: .get, body: body)
    }
}
