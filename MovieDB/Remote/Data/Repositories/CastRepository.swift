//
//  CastRepository.swift
//  MovieDB
//
//  Created by Cuong on 1/31/20.
//  Copyright © 2020 CuongVX-D1. All rights reserved.
//

import Foundation

protocol CasRepository {
    func getCast(id: Int, completion: @escaping (BaseResult<CastResponse>) -> Void)
    func getMovies(id: Int?, completion: @escaping (BaseResult<MoviesByCastResponse>) -> Void)
}

final class CastRepositoryImpl: CasRepository {
    
    private var api: APIService!
    
    required init(api: APIService) {
        self.api = api
    }
    
    func getCast(id: Int, completion: @escaping (BaseResult<CastResponse>) -> Void) {
        let input = CastRequest(id: id)
        guard let api = api else {
            return
        }
        api.request(input: input) { (object: CastResponse?, error) in
            guard let object = object else {
                guard let error = error else {
                    return completion(.failure(error: nil))
                }
                return completion(.failure(error: error))
            }
            completion(.success(object))
        }
    }
    
    func getMovies(id: Int?, completion: @escaping (BaseResult<MoviesByCastResponse>) -> Void) {
        guard let id = id, let api = api else {
            return
        }
        let input = MovieRequest(id: id)
        api.request(input: input) { (object: MoviesByCastResponse?, error) in
            guard let object = object else {
                guard let error = error else {
                    return completion(.failure(error: nil))
                }
                return completion(.failure(error: error))
            }
            completion(.success(object))
        }
    }
}
