//
//  SWSpecies.swift
//  Network
//
//  Created by Dylan Elliott on 12/9/2022.
//

import Foundation
import SwiftUI

struct SWSpecies: Codable, Identifiable, RowDisplayable {
    var title: String { name }
    var id: String { url.absoluteString }
    
    let name: String
    let classification: String
    let designation: String
    let average_height: String
    let skin_colors: String
    let hair_colors: String
    let eye_colors: String
    let average_lifespan: String
    let homeworld: URL?
    let language: String
    let people: [URL]
    let films: [URL]
    let url: URL
}

extension SWSpecies: DetailDisplayable {
    var properties: [(Detail, Detail)] {
        [
            ("Classification", .string(classification)),
            ("Designation", .string(designation)),
            ("Average Height", .string(average_height)),
            ("Skin Colors", .string(skin_colors)),
            ("Hair Colors", .string(hair_colors)),
            ("Eye Colors", .string(eye_colors)),
            ("Average Lifespan", .string(average_lifespan)),
            ("Homeworld", .urlDisplayable(SWPlanet.self, homeworld)),
            ("Language", .string(language))
        ]
    }
    
    var subsections: [(String, [URL], DetailDisplayable.Type)] {
        [
            ("People", people, SWPerson.self),
            ("Films", films, SWFilm.self)
        ]
    }
    
    func detailView() -> AnyView {
        AnyView(DetailView(viewModel: .init(object: self)))
    }
}
