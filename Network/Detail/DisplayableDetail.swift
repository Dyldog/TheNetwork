//
//  DisplayableDetail.swift
//  Network
//
//  Created by Dylan Elliott on 13/9/2022.
//

import Foundation

enum DisplayableDetail {
    case string(String)
    case loading
    case displayable(DetailDisplayable)
}

extension DisplayableDetail {
    var id: String? {
        switch self {
        case .string(let string): return string
        case .loading: return nil
        case .displayable(let detailDisplayable): return detailDisplayable.id
        }
    }
    
    var text: String? {
        switch self {
        case .string(let string): return string
        case .loading: return nil
        case .displayable(let detailDisplayable): return detailDisplayable.title
        }
    }
}
