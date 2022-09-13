//
//  SWAPI.swift
//  Network
//
//  Created by Dylan Elliott on 12/9/2022.
//

import Foundation
import Combine
import SwiftUI

struct SWAPI {
    private static func request<T: Codable>(to url: URL, for type: T.Type) -> AnyPublisher<SWResponse<T>, APIError> {
        URLSession.shared
            .request(of: Request<SWResponse<T>>(url: url))
            .eraseToAnyPublisher()
    }
    
    static func list<T: Codable>(at path: String) -> AnyPublisher<[T], APIError> {
        list(at: .init(string: "https://swapi.dev/api")!.appendingPathComponent(path))
    }
    
    static func list<T: Codable>(at url: URL) -> AnyPublisher<[T], APIError> {
        return request(to: url, for: [T].self).flatMap { (response) -> AnyPublisher<[T], APIError> in
            if let next = response.next {
                return Just(response.results)
                    .setFailureType(to: APIError.self)
                    .eraseToAnyPublisher()
                    .merge(with: list(at: next))
                    .eraseToAnyPublisher()
            } else {
                return Just(response.results)
                    .setFailureType(to: APIError.self)
                    .eraseToAnyPublisher()
            }
        }
        .eraseToAnyPublisher()
    }
    
    static func object<T: Codable>(for url: URL, of type: T.Type) -> AnyPublisher<T, APIError> {
        URLSession.shared
            .request(of: Request<T>(url: url))
            .eraseToAnyPublisher()
    }
}
