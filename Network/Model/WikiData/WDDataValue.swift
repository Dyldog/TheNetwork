//
//  WDDataValue.swift
//  Network
//
//  Created by Dylan Elliott on 13/9/2022.
//

import Foundation

enum WDDataValue: Codable {
    enum ValueType: String, Codable {
        case string
        case wikibaseEntityID = "wikibase-entityid"
        case time
        case quantity
        case monolingualtext
        case globecoordinate
    }
    
    enum CodingKeys: String, CodingKey {
        case value
        case type
    }
    
    case string(String)
    case wikibaseEntityID(WDEntityID)
    case unknownType(String)
    
    var value: String {
        switch self {
        case let .string(string): return string
        case let .wikibaseEntityID(id): return id.id
        case let .unknownType(type): return "\(type): TODO"
        }
    }
    
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let type = try container.decode(ValueType.self, forKey: .type)
            switch type {
            case .string: self = .string(try container.decode(String.self, forKey: .value))
            case .wikibaseEntityID: self = .wikibaseEntityID(try container.decode(WDEntityID.self, forKey: .value))
            case .quantity: self = .string(try container.decode(WDQuantity.self, forKey: .value).display)
            default: self = .unknownType(type.rawValue)
            }
        } catch {
            throw error
        }
    }
    
    func encode(to encoder: Encoder) throws {
        fatalError()
    }
}
