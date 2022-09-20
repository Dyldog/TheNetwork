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
    case blockDisplayable(String, AnyPublisher<any DetailDisplayable, APIError>)
}

extension Detail: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        self = .string(value)
    }
}

extension Detail {
    var stringValue: String? {
        guard case let .string(string) = self else { return nil }
        return string
    }
    func get() -> AnyPublisher<DisplayableDetail, Never> {
        switch self {
        case .string(let string):
            return Just(.string(string.firstCapitalized)).eraseToAnyPublisher()
        case .urlDisplayable(_, nil):
            return Just(.string("Unknown")).eraseToAnyPublisher()
        case let .urlDisplayable(type, .some(url)):
            return type.publisher(for: url)
                .map { .displayable($0) }
                .breakpointOnError()
                .replaceError(with: .string("ERROR"))
                .eraseToAnyPublisher()
        case let .blockDisplayable(_, publisher):
            return publisher.map { .displayable($0) }
                .replaceError(with: .string("ERROR"))
//                .breakpointOnError()
                .eraseToAnyPublisher()
        }
    }
}
