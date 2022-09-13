//
//  DetailDisplayable.swift
//  Network
//
//  Created by Dylan Elliott on 12/9/2022.
//

import Foundation
import Combine
import SwiftUI

protocol DetailDisplayable {
    var id: String { get }
    var title: String { get }
    
    /// A list of properties, title and value, to show in the top info section of the detail screen
    var properties: [(Detail, Detail)] { get }
    
    /// A list of subsections to show on the detail screen
    /// For each section, the following values must be provided:
    ///     - title: `String`: The title of the section
    ///     - urls: `[URL]`: URLs to the values for this section
    ///     - type: `DetailDisplayable.Type`: The type of these values
    var subsections: [(String, [URL], DetailDisplayable.Type)] { get }
    
    
    /// A publisher that returns an object of this type, for the `url` given
    /// - Parameter url: The URL of the resource
    /// - Returns: The publisher
    static func publisher(for url: URL) -> AnyPublisher<DetailDisplayable, APIError>
    
    
    /// The detail view for this object
    /// - Returns: The detail view for this object
    func detailView() -> AnyView
}

extension DetailDisplayable where Self: Codable {
    /// A publisher that returns an object of this type, for the `url` given
    /// - Parameter url: The URL of the resource
    /// - Returns: The publisher
    static func publisher(for url: URL) -> AnyPublisher<DetailDisplayable, APIError> {
        SWAPI.object(for: url, of: Self.self)
            .map { $0 as DetailDisplayable }
            .eraseToAnyPublisher()
    }
}
