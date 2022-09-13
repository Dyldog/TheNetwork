//
//  Request.swift
//  Network
//
//  Created by Dylan Elliott on 12/9/2022.
//

import Foundation

public struct Request<Response: Decodable> {
    let url: URL
}

public extension Request {
    var urlRequest: URLRequest {
        let request = URLRequest(url: url)
        return request
    }
}
