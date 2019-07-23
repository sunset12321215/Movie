//
//  CustomRequestAdapter.swift
//  Movie
//
//  Created by pham.xuan.tien on 12/28/18.
//  Copyright © 2018 Framgia. All rights reserved.
//

import Alamofire
import Foundation

class CustomRequestAdapter: RequestAdapter {
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return urlRequest
    }
}
