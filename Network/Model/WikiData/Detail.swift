//
//  Detail.swift
//  Network
//
//  Created by Dylan Elliott on 13/9/2022.
//

import Foundation
import Combine

enum Detail {
    case string(String)
    case urlDisplayable(DetailDisplayable.Type, URL?)
    case blockDisplayable(AnyPublisher<any DetailDisplayable, APIError>)
}

extension Detail: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        self = .string(value)
    }
}

extension Detail {
    func get() -> AnyPublisher<DisplayableDetail, Never> {
        switch self {
        case .string(let string):
            return Just(.string(string.firstCapitalized)).eraseToAnyPublisher()
        case .urlDisplayable(_, nil):
            return Just(.string("Unknown")).eraseToAnyPublisher()
        case let .urlDisplayable(type, .some(url)):
            return type.publisher(for: url)
                .map { .displayable($0) }
                .replaceError(with: .string("ERROR"))
                .eraseToAnyPublisher()
        case .blockDisplayable(let publisher):
            return publisher.map { .displayable($0) }
                .replaceError(with: .string("ERROR"))
                .eraseToAnyPublisher()
        }
    }
}
