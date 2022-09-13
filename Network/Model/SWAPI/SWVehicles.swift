//
//  SWVehicles.swift
//  Network
//
//  Created by Dylan Elliott on 12/9/2022.
//

import Foundation
import SwiftUI
import Combine
struct SWVehicle: Codable, Identifiable, RowDisplayable {
    var id: String { url.absoluteString }
    var title: String { name }
    let name: String
    let url: URL
}

extension SWVehicle: DetailDisplayable {
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
