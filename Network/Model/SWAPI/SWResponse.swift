//
//  SWResponse.swift
//  Network
//
//  Created by Dylan Elliott on 12/9/2022.
//

import Foundation

struct SWResponse<T: Codable>: Codable {
    let results: T
    let next: URL?
}
