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
    func getCredit(id: Int, completion: @escaping (BaseResult<CreditResponse>) -> Void)
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
    
    func getMoviesByID(id: Int?, page: Int?, completion: @escaping (BaseResult<MoviesResponse>) -> Void) {
        guard let id = id,
            let api = api,
            let page = page else {
                return
        }
        let input = MovieRequest(id: id, page: page)
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
    
    func getCredit(id: Int, completion: @escaping (BaseResult<CreditResponse>) -> Void) {
        let input = CreditRequest(id: id)
        guard let api = api else {
            return
        }
        api.request(input: input) { (object: CreditResponse?, error) in
            guard let object = object else {
                guard let error = error else {
                    return completion(.failure(error: nil))
                }
                return completion(.failure(error: error))
            }
            completion(.success(object))
        }
    }
    
    func searchMovie(text: String, page: Int, completion: @escaping (BaseResult<MoviesResponse>) -> Void) {
        guard let api = api else { return }
        let input = SearchRequest(text: text, page: page)
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
    
    func getVideos(id: Int, completion: @escaping (BaseResult<VideosResponse>) -> Void) {
        guard let api = api else { return }
        let input = VideoRequest(id: id)
        api.request(input: input) { (object: VideosResponse?, error) in
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
