//
//  MovieRepository.swift
//  MovieDB
//
//  Created by CuongVX-D1 on 7/23/19.
//  Copyright © 2019 CuongVX-D1. All rights reserved.
//

import Foundation

protocol MovieRepository {
    func getMovies(type: MovieType, page: Int, completion: @escaping (BaseResult<MoviesResponse>) -> Void)
    func getGenreList(completion: @escaping (BaseResult<GenreResponse>) -> Void)
}

final class MovieRepositoryImpl: MovieRepository {
    
    private var api: APIService!
    
    required init(api: APIService) {
        self.api = api
    }
    
    func getMovies(type: MovieType, page: Int, completion: @escaping (BaseResult<MoviesResponse>) -> Void) {
        guard let api = api else { return }
        let input = MovieRequest(type: type, page: page)
        api.request(input: input) { (object: MoviesResponse?, error) in
            guard let object = object else {
                guard let error = error else {
                    return completion(.failure(error: nil))
                }
                return completion(.failure(error: error))
            }
            completion(.success(object))
        }
    }
    
    func getGenreList(completion: @escaping (BaseResult<GenreResponse>) -> Void) {
        guard let api = api else { return }
        let input = GenreRequest()
        api.request(input: input) { (object: GenreResponse?, error) in
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
