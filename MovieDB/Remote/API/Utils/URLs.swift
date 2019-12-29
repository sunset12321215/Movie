//
//  URLs.swift
//  Movie

struct URLs {
    private static let APIBaseUrl = "https://api.themoviedb.org/3"
    static let APIImagesOriginalPath = "https://image.tmdb.org/t/p/original"
    static let APIImagesPath = "https://image.tmdb.org/t/p/w500"
    static let APIMovieNowPlayingURL = APIBaseUrl + "/movie/now_playing"
    static let APIMovieUpcomingURL = APIBaseUrl + "/movie/upcoming"
    static let APIMoviePopularURL = APIBaseUrl + "/movie/popular"
    static let APIMovieTopRatedURL = APIBaseUrl + "/movie/top_rated"
    static let APIMovieDetailURL = APIBaseUrl + "/movie/"
    static let APISearchURL = APIBaseUrl + "/search/movie"
    static let APIGenreListURL = APIBaseUrl + "/genre/movie/list"
    static let APIDiscoverMovieURL = APIBaseUrl + "/discover/movie"
    static let YoutubeThumbnailImage = "https://img.youtube.com/vi/%@/hqdefault.jpg"
    static let APIGetMovieByID = APIBaseUrl + "/genre/"
    static let APIPersonDetailURL = APIBaseUrl + "/person/"
}
