//
//  WDQuantity.swift
//  Network
//
//  Created by Dylan Elliott on 13/9/2022.
//

import Foundation

struct WDQuantity: Codable {
    let amount: String
    let unit: String
    
    var display: String { "\(amount)\(unit)"}
}
