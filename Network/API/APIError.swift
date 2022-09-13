//
//  APIError.swift
//  Network
//
//  Created by Dylan Elliott on 12/9/2022.
//

import Foundation

public enum RequestError: Error {
    case notConnectedToInternet
    case unknown
}

public enum ResponseError: Error {
    case decoding(DecodingError)
    case unknown
}

public enum APIError : Error {
    case request(RequestError)
    case response(ResponseError)
}

// MARK: - Transformers

extension Error {
    var requestError: RequestError {
        switch self {
        case let url as URLError:
            return url.requestError
        default:
            return .unknown
        }
    }
    
    var responseError: ResponseError {
        switch self {
        case let decoding as DecodingError:
            return .decoding(decoding)
        default:
            return .unknown
        }
    }
}

extension URLError {
    var requestError: RequestError {
        switch self.code {
        case .notConnectedToInternet, .networkConnectionLost:
            return .notConnectedToInternet
        default:
            return .unknown
        }
    }
}
