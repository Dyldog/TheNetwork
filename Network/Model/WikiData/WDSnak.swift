//
//  WDSnak.swift
//  Network
//
//  Created by Dylan Elliott on 13/9/2022.
//

import Foundation

struct WDSnak: Codable {
    let property: String
    var propertyName: String { wikiData(property: property) }
    let datavalue: WDDataValue?
}
