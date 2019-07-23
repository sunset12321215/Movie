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
}
