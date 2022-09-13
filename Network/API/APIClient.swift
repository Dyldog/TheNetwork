//
//  APIClient.swift
//  Network
//
//  Created by Dylan Elliott on 12/9/2022.
//

import Foundation
import Combine

public extension URLSession {
    func request<Response>(of request: Request<Response>) -> AnyPublisher<Response, APIError> {
        self.dataTaskPublisher(for: request.urlRequest)
            .mapError {
                $0.requestError
            }
            .tryMap { data, response in
                do {
                    return try JSONDecoder().decode(Response.self, from: data)
                } catch {
                    throw error
                }
            }
            .mapError {
                switch $0 {
                case let request as RequestError:
                    return APIError.request(request)
                default:
                    return APIError.response($0.responseError)
                }
            }
            .eraseToAnyPublisher()
    }
}
