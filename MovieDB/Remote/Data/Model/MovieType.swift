//
//  MovieType.swift
//  MovieDB
//
//  Created by CuongVX-D1 on 7/23/19.
//  Copyright © 2019 CuongVX-D1. All rights reserved.
//

import Foundation

enum MovieType: CaseIterable {
    case now, upcoming, popular, top
    
    var name: String {
        switch self {
        case .now:
            return "Now playing"
        case .upcoming:
            return "Up coming"
        case .popular:
            return "Popular"
        case .top:
            return "Top Rated"
        }
    }
    var url: String {
        switch self {
        case .now:
            return URLs.APIMovieNowPlayingURL
        case .upcoming:
            return URLs.APIMovieUpcomingURL
        case .popular:
            return URLs.APIMoviePopularURL
        case .top:
            return URLs.APIMovieTopRatedURL
        }
    }
}
