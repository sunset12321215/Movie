//
//  Storyboards.swift
//  MovieDB
//
//  Created by Cuong on 12/29/19.
//  Copyright © 2019 CuongVX-D1. All rights reserved.
//

import UIKit

struct Storyboards {
    static let walkThrough = UIStoryboard(name: "WalkThrough", bundle: nil)
    static let movieDetail = UIStoryboard(name: "MovieDetail", bundle: nil)
    static let main = UIStoryboard(name: "Main", bundle: nil)
    static let movieViewController = main.instantiateViewController(withIdentifier: "movieVC")
    static let categoriesViewController = main.instantiateViewController(withIdentifier: "categoriesVC")
    static let favoriteViewController = main.instantiateViewController(withIdentifier: "favoriteVC")
    static let movieByGenre = UIStoryboard(name: "MovieByGenre", bundle: nil)
    static let trailer = UIStoryboard(name: "Trailer", bundle: nil)
    static let castDetail = UIStoryboard(name: "CastDetail", bundle: nil)
    static let search = UIStoryboard(name: "Search", bundle: nil)
}
