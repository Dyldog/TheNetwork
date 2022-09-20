//
//  WDProperties.swift
//  Network
//
//  Created by Dylan Elliott on 12/9/2022.
//

import Foundation

private struct WikiDataPropertyDump: Codable {
    let rows: [[String]]
}

private var wikiDataProperties: [String: String] = {
    let url = Bundle.main.url(forResource: "wdentities", withExtension: "json")!
    let data = try! Data(contentsOf: url)
    return try! JSONDecoder().decode(WikiDataPropertyDump.self, from: data).rows.reduce(into: [:]) { dict, row in
        dict[row[0]] = row[1]
    }
}()

func wikiData(property: String) -> String {
    wikiDataProperties[property] ?? property
}

enum Properties: String {
    case formatterURL = "P1630"
}
