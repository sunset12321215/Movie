//
//  BaseResult.swift
//  Movie

import Foundation
import ObjectMapper

enum BaseResult<T: Mappable> {
    case success(T?)
    case failure(error: BaseError?)
}
