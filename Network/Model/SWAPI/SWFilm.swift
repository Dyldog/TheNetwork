//
//  SWFilm.swift
//  Network
//
//  Created by Dylan Elliott on 12/9/2022.
//

import Foundation
import SwiftUI

struct SWFilm: Codable, Identifiable, RowDisplayable {
    var id: String { url.absoluteString }
    let url: URL
    let title: String
    let director: String
    let producer: String
    let release_date: String
    let episode_id: Int
    let opening_crawl: String
    
    let characters: [URL]
    let planets: [URL]

}

extension SWFilm: DetailDisplayable {
    var properties: [(Detail, Detail)] { [
        ("Director", .string(director)),
        ("Producer", .string(producer)),
        ("Release Date", .string(release_date)),
        ("Episode ID", .string("\(episode_id)")),
        ("Opening Crawl", .string(opening_crawl)),
    ] }
    
    var subsections: [(String, [URL], DetailDisplayable.Type)] { [
        ("Characters", characters, SWPerson.self),
        ("Planets", planets, SWPlanet.self),
    ] }
    
    func detailView() -> AnyView {
        AnyView(DetailView(viewModel: .init(object: self)))
    }
}
