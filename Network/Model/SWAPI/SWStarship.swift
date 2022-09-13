//
//  SWStarship.swift
//  Network
//
//  Created by Dylan Elliott on 12/9/2022.
//

import Foundation
import SwiftUI

struct SWStarship: Codable, Identifiable, RowDisplayable {
    let name: String
    let url: URL
    var id: String { url.absoluteString }
    var title: String { name }
}

extension SWStarship: DetailDisplayable {
    var properties: [(Detail, Detail)] {
        []
    }
    
    var subsections: [(String, [URL], DetailDisplayable.Type)] {
        []
    }
    
    func detailView() -> AnyView {
        AnyView(DetailView(viewModel: .init(object: self)))
    }
}
