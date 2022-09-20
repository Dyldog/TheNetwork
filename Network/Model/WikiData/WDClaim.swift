//
//  WDClaim.swift
//  Network
//
//  Created by Dylan Elliott on 13/9/2022.
//

import Foundation

struct WDClaim: Codable {
    let mainsnak: WDSnak
    let rank: Rank
}

extension WDClaim {
    enum Rank: String, Codable {
        case normal
        case preferred
        case deprecated
    }
}
