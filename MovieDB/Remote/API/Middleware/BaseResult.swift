//
//  BaseResult.swift
//  Movie
//
//  Created by pham.xuan.tien on 12/28/18.
//  Copyright © 2018 Framgia. All rights reserved.
//

import Foundation
import ObjectMapper

enum BaseResult<T: Mappable> {
    case success(T?)
    case failure(error: BaseError?)
}
