//
//  WDEntityID.swift
//  Network
//
//  Created by Dylan Elliott on 13/9/2022.
//

import Foundation

struct WDEntityID: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case entityType = "entity-type"
    }
    let id: String
    let entityType: WDEntityType
}
