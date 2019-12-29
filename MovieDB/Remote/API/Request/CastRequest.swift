//
//  CastRequest.swift
//  MovieDB
//
//  Created by Cuong on 1/31/20.
//  Copyright © 2020 CuongVX-D1. All rights reserved.
//

import Foundation

class CastRequest: BaseRequest {
    required init(id: Int) {
        let body: [String: Any] = [
            "language": "en-US",
            ]
        let url = URLs.APIPersonDetailURL + "\(id)"
        super.init(url: url, requestType: .get, body: body)
    }
}
