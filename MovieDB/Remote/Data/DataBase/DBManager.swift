//
//  DBManage.swift
//  MovieDB
//
//  Created by Cuong on 3/3/20.
//  Copyright © 2020 CuongVX-D1. All rights reserved.
//

import Foundation

class DBManager {
    private var database: Realm!
    static let shareInstance = DBManager()

    
    private init() {
        database = try? Realm()
    }
    
    func getData() -> [Movie] {
        return Array(database.objects(Movie.self))
    }
    
    func addFavoriteMovie(movie: Movie) {
        try? database.write {
            database.add(movie)
        }
    }
    
    func removeFavoriteMovie(movie: Movie) {
        try? database.write {
            database.delete(movie)
        }
    }
    
    func isMovieInDataBase(movie: Movie) -> Bool {
        let result = database.objects(Movie.self).filter("id == \(movie.id)").first
        return result == nil ? false : true
    }
    
    func searchMovie(id: Int) -> Movie {
        guard let result = database.objects(Movie.self).filter("id == \(id)").first else { return Movie() }
        return result
    }
}
