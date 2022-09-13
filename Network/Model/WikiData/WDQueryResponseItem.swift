//
//  WDQueryResponseItem.swift
//  Network
//
//  Created by Dylan Elliott on 13/9/2022.
//

import Foundation

struct WDQueryResponseItem: Codable {
    let title: String // is actually entity ID (QID)
}
