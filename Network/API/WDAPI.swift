//
//  WDAPI.swift
//  Network
//
//  Created by Dylan Elliott on 13/9/2022.
//

import Foundation
import Combine

struct WDAPI {
    static func search(for query: String) -> AnyPublisher<[WDEntity], APIError> {
        let sanitisedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let url: URL = .init(string: "https://www.wikidata.org/w/api.php?action=wbsearchentities&format=json&search=\(sanitisedQuery)&language=en")!
        return URLSession.shared
            .request(of: Request<WDSearchResponse>(url: url))
            .flatMap { (entity: WDSearchResponse) -> AnyPublisher<[WDEntity], APIError> in
                getEntities(entity.search.map { $0.id })
            }
            .eraseToAnyPublisher()
    }
    
    static func getEntities(_ ids: [String]) -> AnyPublisher<[WDEntity], APIError> {
        let url: URL = .init(string: "https://www.wikidata.org/w/api.php?action=wbgetentities&ids=\(ids.joined(separator: "%7C"))&languages=en&format=json")!
        return URLSession.shared
            .request(of: Request<WDEntityResponse>(url: url))
            .map { Array($0.entities.values) }
            .eraseToAnyPublisher()
    }
    
    static func getEntity(_ id: String) -> AnyPublisher<DetailDisplayable, APIError> {
        getEntities([id])
            .tryMap { (entities: [WDEntity]) -> DetailDisplayable in
                guard let first = entities.first else {
                    throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "No first value"))
                }
                return first
            }
            .mapError { .response($0.responseError) }
            .eraseToAnyPublisher()
    }
    
    static func otherExamples(of property: String? = nil, equalTo value: String? = nil) -> AnyPublisher<[WDEntity], APIError> {
        let query = [property, value].compactMap { $0 }.joined(separator: "=")
        guard let url: URL = .init(string: "https://www.wikidata.org/w/api.php?action=query&format=json&list=search&srsearch=haswbstatement:\(query)")
        else { return Fail(error: APIError.request(.unknown)).eraseToAnyPublisher() }
        return URLSession.shared
            .request(of: Request<WDFindResponse>(url: url))
            .flatMap { (entity: WDFindResponse) -> AnyPublisher<[WDEntity], APIError> in
                getEntities(entity.query.search.map { $0.title })
            }
//            .map { $0 as [DetailDisplayable] }
            .eraseToAnyPublisher()
    }
}
