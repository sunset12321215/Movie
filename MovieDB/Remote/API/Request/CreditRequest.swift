//
//  CreditRequest.swift
//  MovieDB
//
//  Created by Cuong on 1/4/20.
//  Copyright © 2020 CuongVX-D1. All rights reserved.
//

import Foundation

class CreditRequest: BaseRequest {
    required init(id: Int) {
        let body: [String: Any] = [
            "language": "en-US"
        ]
        let url = URLs.APIMovieDetailURL + "\(id)" + "/credits"
        super.init(url: url, requestType: .get, body: body)
    }
}
