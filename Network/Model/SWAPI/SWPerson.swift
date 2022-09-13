//
//  SWPerson.swift
//  Network
//
//  Created by Dylan Elliott on 12/9/2022.
//

import Foundation
import SwiftUI

struct SWPerson: Codable, Identifiable, RowDisplayable {
    var id: String { url.absoluteString }
    let name: String
    let birth_year: String
    let gender: String
    let hair_color: String
    let mass: String
    let skin_color: String
    let homeworld: URL?
    let species: [URL]
    
    let url: URL
    let films: [URL]
    let vehicles: [URL]
    let starships: [URL]
    
    var title: String { name }
}

extension SWPerson: DetailDisplayable {
    var properties: [(Detail, Detail)] {
        [
            ("Homeworld", .urlDisplayable(SWPlanet.self, homeworld)),
            ("Birth Year", .string(birth_year)),
            ("Gender", .string(gender)),
            ("Hair Color", .string(hair_color)),
            ("Mass", .string(mass)),
            ("Skin Color", .string(skin_color)),
        ]
    }
    
    var subsections: [(String, [URL], DetailDisplayable.Type)] {
        [
            ("Species", species, SWSpecies.self),
            ("Films", films, SWFilm.self),
            ("Vehicles", vehicles, SWVehicle.self),
            ("Starships", starships, SWStarship.self)
        ]
    }
    
    func detailView() -> AnyView {
        AnyView(DetailView(viewModel: .init(object: self)))
    }
}
