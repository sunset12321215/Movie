//
//  MovieRequest.swift
//  Movie

class MovieRequest: BaseRequest {
    required init(type: MovieType, page: Int) {
        let body: [String: Any]  = [
            "page": page
        ]
        super.init(url: type.url, requestType: .get, body: body)
    }
    
    required init(id: Int, page: Int) {
        let body: [String: Any]  = [
            "page": page
        ]
        let url = URLs.APIGetMovieByID + "\(id)" + "/movies"
        super.init(url: url, requestType: .get, body: body)
    }
    
    required init(id: Int) {
        let body: [String: Any] = [
            "language": "en-US"
        ]
        let url = URLs.APIPersonDetailURL + "\(id)" + "/movie_credits"
        super.init(url: url, requestType: .get, body: body)
    }
}
