//
//  WDEntityResponse.swift
//  Network
//
//  Created by Dylan Elliott on 13/9/2022.
//

import Foundation

struct WDEntityResponse: Codable {
    let entities: [String: WDEntity]
}
