//
//  WDSearchResult.swift
//  Network
//
//  Created by Dylan Elliott on 13/9/2022.
//

import Foundation

struct WDSearchResult: Codable {
    let id: String
    let display: WDDisplay
}

extension WDSearchResult {
    var displayTitle: String { display.label.value }
}
