//
//  APIService.swift
//  Movie
//
//  Created by pham.xuan.tien on 12/28/18.
//  Copyright © 2018 Framgia. All rights reserved.
//

import Alamofire
import ObjectMapper

struct APIService {
    static let share = APIService()
    private var alamofireManager = Alamofire.SessionManager.default

    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        alamofireManager = Alamofire.SessionManager(configuration: configuration)
        alamofireManager.adapter = CustomRequestAdapter()
    }

    func request<T: Mappable>(input: BaseRequest, completion: @escaping (_ value: T?, _ error: BaseError?) -> Void) {

        print("\n------------REQUEST INPUT")
        print("Link: %@", input.url)
        print("Body: %@", input.body ?? "No Body")
        print("------------ END REQUEST INPUT\n")

        alamofireManager.request(input.url, method: input.requestType, parameters: input.body, encoding: input.encoding)
            .validate(statusCode: 200..<500)
            .responseJSON { response in
                print(response.request?.url ?? "Error")
                print(response)
                switch response.result {
                case .success(let value):
                    guard let statusCode = response.response?.statusCode else {
                        completion(nil, BaseError.unexpectedError)
                        return
                    }
                    if statusCode == 200 {
                        let object = Mapper<T>().map(JSONObject: value)
                        completion(object, nil)
                    } else {
                        guard let error = Mapper<ErrorResponse>().map(JSONObject: value) else {
                            completion(nil, BaseError.httpError(httpCode: statusCode))
                            return
                        }
                        completion(nil, BaseError.apiFailure(error: error))
                    }
                case .failure(let error):
                    completion(nil, error as? BaseError)
                }
        }
    }
}
