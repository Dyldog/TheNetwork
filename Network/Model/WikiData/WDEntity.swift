//
//  WDEntity.swift
//  Network
//
//  Created by Dylan Elliott on 13/9/2022.
//

import Foundation
import SwiftUI

struct WDEntity: Codable {
    let id: String
    let labels: WDLanguageValue
    let descriptions: WDLanguageValue
    let claims: [String: [WDClaim]]
}

extension WDEntity: Identifiable { }
 
extension WDEntity: RowDisplayable {
    var title: String { labels.en?.value ?? "NO_LABEL (\(id))" }
}

extension WDEntity: DetailDisplayable {
    var properties: [(Detail, Detail)] {
        [
            ("Description", .string(descriptions.en?.value ?? "NONE")),
            ("Entity ID", .string(id))
        ] + claims.flatMap { $0.value }.filter { $0.rank != .deprecated }.compactMap {
            let id = $0.mainsnak.property
            let title: Detail = .blockDisplayable(id, WDAPI.getEntity(id))
            switch $0.mainsnak.datavalue {
            case nil: return nil
            case let .string(string):
                return (title,.string(string))
            case let .wikibaseEntityID(entityID):
                return (title, .blockDisplayable(entityID.id, WDAPI.getEntity(entityID.id)))
            case .unknownType: return (.blockDisplayable($0.mainsnak.property, WDAPI.getEntity($0.mainsnak.property)), .string("Unknown"))
            }
        }
    }
    
    var subsections: [(String, [URL], DetailDisplayable.Type)] {
        []
    }
    
    func detailView() -> AnyView {
        AnyView(DetailView(viewModel: .init(object: self)))
    }
}
