//
//  VideoRequest.swift
//  MovieDB
//
//  Created by Cuong on 1/23/20.
//  Copyright © 2020 CuongVX-D1. All rights reserved.
//

import Foundation

class VideoRequest: BaseRequest {
    required init(id: Int) {
        let body: [String: Any] = [
            "language": "en-US",
        ]
        let url = URLs.APIMovieDetailURL + "\(id)" + "/videos"
        super.init(url: url, requestType: .get, body: body)
    }
}
