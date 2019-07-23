//
//  BaseError.swift
//  Movie

enum BaseError: Error {
    case networkError
    case httpError(httpCode: Int)
    case unexpectedError
    case apiFailure(error: ErrorResponse?)

    struct Errors {
        // Error message
        static let networkError = "Network Error"
        static let error = "Error"
        static let unexpectedError = "Unexpected Error"
        static let redirectionError = "It was transferred to a different URL. I'm sorry for causing you trouble"
        static let clientError = "An error occurred on the application side. Please try again later!"
        static let serverError = "A server error occurred. Please try again later!"
        static let unofficalError = "An error occurred. Please try again later!"
    }

    public var errorMessage: String? {
        switch self {
        case .networkError:
            return Errors.networkError
        case .httpError(let code):
            return getHttpErrorMessage(httpCode: code)
        case .apiFailure(let error):
            if let error = error {
                return error.message
            }
            return Errors.error
        default:
            return Errors.unexpectedError
        }
    }

    private func getHttpErrorMessage(httpCode: Int) -> String? {
        switch HTTPStatusCode(rawValue: httpCode)?.responseType {
        case .redirection?:
            return Errors.redirectionError
        case .clientError?:
            return Errors.clientError
        case .serverError?:
            return Errors.serverError
        default:
            return Errors.unofficalError
        }
    }
}
