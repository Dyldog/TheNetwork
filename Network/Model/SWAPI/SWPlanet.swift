//
//  SWPlanet.swift
//  Network
//
//  Created by Dylan Elliott on 12/9/2022.
//

import Foundation
import SwiftUI

struct SWPlanet: Codable, Identifiable, RowDisplayable {
    var id: String { url.absoluteString }
    let url: URL
    let name: String
    var title: String { name }
    
    let rotation_period: String
    let orbital_period: String
    let diameter: String
    let climate: String
    let gravity: String
    let terrain: String
    let surface_water: String
    let population: String
    let residents: [URL]
    let films: [URL]
}

extension SWPlanet: DetailDisplayable {
    var properties: [(Detail, Detail)] {
        [
            ("Rotation Period", .string(rotation_period)),
            ("Orbital Period", .string(orbital_period)),
            ("Diameter", .string(diameter)),
            ("Climate", .string(climate)),
            ("Gravity", .string(gravity)),
            ("Terrain", .string(terrain)),
            ("Surface Water", .string(surface_water)),
            ("Population", .string(population)),
        ]
    }
    
    var subsections: [(String, [URL], DetailDisplayable.Type)] {
        [
            ("Residents", residents, SWPerson.self),
            ("Films", films, SWFilm.self)
        ]
    }
    
    func detailView() -> AnyView {
        AnyView(DetailView(viewModel: .init(object: self)))
    }
}
